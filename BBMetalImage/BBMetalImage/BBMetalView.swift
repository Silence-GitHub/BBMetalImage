//
//  BBMetalView.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/8/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import MetalKit

fileprivate class BBMetalTextureNode {
    fileprivate var next: BBMetalTextureNode?
    fileprivate let value: MTLTexture
    
    fileprivate init(value: MTLTexture) { self.value = value }
}

fileprivate class BBMetalTextureQueue {
    fileprivate var head: BBMetalTextureNode?
    fileprivate var tail: BBMetalTextureNode?
    
    fileprivate func enqueue(_ value: MTLTexture) {
        let node = BBMetalTextureNode(value: value)
        if head == nil {
            head = node
            tail = node
        } else {
            tail?.next = node
            tail = node
        }
    }
    
    fileprivate func dequeue() -> MTLTexture? {
        if let value = head?.value {
            head = head?.next
            if head == nil { tail = nil }
            return value
        }
        return nil
    }
}

public class BBMetalView: MTKView {
    public enum TextureRotation {
        case rotate0Degrees
        case rotate90Degrees
        case rotate180Degrees
        case rotate270Degrees
    }
    
    public enum TextureContentMode {
        case aspectRatioFill
        case aspectRatioFit
        case stretch
    }
    
    public var bb_textureMirroring: Bool {
        get {
            lock.wait()
            let m = tempTextureMirroring
            lock.signal()
            return m
        }
        set {
            lock.wait()
            tempTextureMirroring = newValue
            lock.signal()
        }
    }
    
    public var bb_textureRotation: TextureRotation {
        get {
            lock.wait()
            let r = tempTextureRotation
            lock.signal()
            return r
        }
        set {
            lock.wait()
            tempTextureRotation = newValue
            lock.signal()
        }
    }
    
    public var bb_textureContentMode: TextureContentMode {
        get {
            lock.wait()
            let c = tempTextureContentMode
            lock.signal()
            return c
        }
        set {
            lock.wait()
            tempTextureContentMode = newValue
            lock.signal()
        }
    }
    
    private var _bounds: CGRect
    
    private var textureWidth: Int = 0
    private var textureHeight: Int = 0
    
    private var textureMirroring = false // for internal drawing
    private var tempTextureMirroring = false // for external setter
    
    private var textureRotation: TextureRotation = .rotate0Degrees // for internal drawing
    private var tempTextureRotation: TextureRotation = .rotate0Degrees // for external setter
    
    private var textureContentMode: TextureContentMode = .aspectRatioFill // for internal drawing
    private var tempTextureContentMode: TextureContentMode = .aspectRatioFill // for external setter
    
    private let textureQueue: BBMetalTextureQueue
    private let lock: DispatchSemaphore
    
    private lazy var renderPipeline: MTLRenderPipelineState = {
        let library = try! device!.makeDefaultLibrary(bundle: Bundle(for: BBMetalView.self))
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "TexturePipeline"
        descriptor.vertexFunction = library.makeFunction(name: "vertexPassThrough")!
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentPassThrough")!
        descriptor.colorAttachments[0].pixelFormat = colorPixelFormat
        return try! device!.makeRenderPipelineState(descriptor: descriptor)
    }()
    
    private var vertexCoordinateBuffer: MTLBuffer?
    private var textureCoordinateBuffer: MTLBuffer?
    
    public override init(frame frameRect: CGRect, device: MTLDevice?) {
        _bounds = CGRect(origin: .zero, size: frameRect.size)
        textureQueue = BBMetalTextureQueue()
        lock = DispatchSemaphore(value: 1)
        super.init(frame: frameRect, device: device ?? BBMetalDevice.sharedDevice)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        lock.wait()
        defer { lock.signal() }
        
        guard let texture = self.textureQueue.dequeue(),
            let drawable = currentDrawable,
            let renderPassDescriptor = currentRenderPassDescriptor,
            let commandBuffer = BBMetalDevice.sharedCommandQueue.makeCommandBuffer() else { return }
        
        if bounds != _bounds ||
            texture.width != textureWidth ||
            texture.height != textureHeight ||
            tempTextureMirroring != textureMirroring ||
            tempTextureRotation != textureRotation ||
            tempTextureContentMode != textureContentMode {
            setupTransform(withWidth: texture.width, height: texture.height)
        }
        
        guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        
        commandBuffer.label = "RenderPassThroughCommand"
        
        encoder.label = "RenderPassThroughEncoder"
        
        encoder.setViewport(MTLViewport(originX: 0,
                                        originY: 0,
                                        width: Double(drawableSize.width),
                                        height: Double(drawableSize.height),
                                        znear: -1,
                                        zfar: 1))
        
        encoder.setRenderPipelineState(renderPipeline)
        
        encoder.setVertexBuffer(vertexCoordinateBuffer, offset: 0, index: 0)
        encoder.setVertexBuffer(textureCoordinateBuffer, offset: 0, index: 1)
        encoder.setFragmentTexture(texture, index: 0)
        
        encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
        
        encoder.endEncoding()
        
        commandBuffer.present(drawable)
        
        commandBuffer.commit()
    }
}

extension BBMetalView: BBMetalImageConsumer {
    public func add(source: BBMetalImageSource) {}
    public func remove(source: BBMetalImageSource) {}
    
    public func newTextureAvailable(_ texture: MTLTexture, from source: BBMetalImageSource) {
        lock.wait()
        self.textureQueue.enqueue(texture)
        lock.signal()
    }
    
    private func setupTransform(withWidth width: Int, height: Int) {
        _bounds = bounds
        textureWidth = width
        textureHeight = height
        textureMirroring = tempTextureMirroring
        textureRotation = tempTextureRotation
        textureContentMode = tempTextureContentMode
        
        var scaleX: Float = 1
        var scaleY: Float = 1
        
        if textureContentMode != .stretch {
            if textureWidth > 0 && textureHeight > 0 {
                switch textureRotation {
                case .rotate0Degrees, .rotate180Degrees:
                    scaleX = Float(_bounds.width / CGFloat(textureWidth))
                    scaleY = Float(_bounds.height / CGFloat(textureHeight))
                    
                case .rotate90Degrees, .rotate270Degrees:
                    scaleX = Float(_bounds.width / CGFloat(textureHeight))
                    scaleY = Float(_bounds.height / CGFloat(textureWidth))
                }
            }
            
            if scaleX < scaleY {
                if textureContentMode == .aspectRatioFill {
                    scaleX = scaleY / scaleX
                    scaleY = 1
                } else {
                    scaleY = scaleX / scaleY
                    scaleX = 1
                }
            } else {
                if textureContentMode == .aspectRatioFill {
                    scaleY = scaleX / scaleY
                    scaleX = 1
                } else {
                    scaleX = scaleY / scaleX
                    scaleY = 1
                }
            }
        }
        
        if textureMirroring { scaleX = -scaleX }
        
        let vertexData: [Float] = [
            -scaleX, -scaleY,
            +scaleX, -scaleY,
            -scaleX, +scaleY,
            +scaleX, +scaleY,
        ]
        vertexCoordinateBuffer = device!.makeBuffer(bytes: vertexData, length: vertexData.count * MemoryLayout<Float>.size, options: [])
        
        var textData: [Float]
        switch textureRotation {
        case .rotate0Degrees:
            textData = [
                0.0, 1.0,
                1.0, 1.0,
                0.0, 0.0,
                1.0, 0.0
            ]
        case .rotate180Degrees:
            textData = [
                1.0, 0.0,
                0.0, 0.0,
                1.0, 1.0,
                0.0, 1.0
            ]
        case .rotate90Degrees:
            textData = [
                1.0, 1.0,
                1.0, 0.0,
                0.0, 1.0,
                0.0, 0.0
            ]
        case .rotate270Degrees:
            textData = [
                0.0, 0.0,
                0.0, 1.0,
                1.0, 0.0,
                1.0, 1.0
            ]
        }
        textureCoordinateBuffer = device?.makeBuffer(bytes: textData, length: textData.count * MemoryLayout<Float>.size, options: [])
    }
}
