//
//  BBMetalView.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/8/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import MetalKit

private var vertexCoordinate: [Float] = [-1, +1,
                                         +1, +1,
                                         -1, -1,
                                         +1, -1]

private var textureCoordinate: [Float] = [0, 1,
                                          1, 1,
                                          0, 0,
                                          1, 0]

public class BBMetalView: MTKView {
    enum Rotation: Int {
        case rotate0Degrees
        case rotate90Degrees
        case rotate180Degrees
        case rotate270Degrees
    }
    
    private var textureWidth: Int = 0
    private var textureHeight: Int = 0
    private var textureMirroring = false
    private var textureRotation: Rotation = .rotate0Degrees
    private var internalBounds: CGRect
    private var texture: MTLTexture?
    
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
        internalBounds = CGRect(origin: .zero, size: frameRect.size)
        super.init(frame: frameRect, device: device)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        guard let texture = self.texture,
            let drawable = currentDrawable,
            let renderPassDescriptor = currentRenderPassDescriptor,
            let commandBuffer = BBMetalDevice.sharedCommandQueue.makeCommandBuffer() else { return }
        
        if texture.width != textureWidth ||
            texture.height != textureHeight ||
            self.bounds != internalBounds {
            setupTransform(width: texture.width, height: texture.height, mirroring: false, rotation: .rotate90Degrees)
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
        
        encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: vertexCoordinate.count / 2)
        
        encoder.endEncoding()
        
        commandBuffer.present(drawable)
        
        commandBuffer.commit()
    }
}

extension BBMetalView: BBMetalImageConsumer {
    public func add(source: BBMetalImageSource) {}
    public func remove(source: BBMetalImageSource) {}
    
    public func newTextureAvailable(_ texture: MTLTexture, from source: BBMetalImageSource) {
        self.texture = texture
    }
    
    private func setupTransform(width: Int, height: Int, mirroring: Bool, rotation: Rotation) {
        var scaleX: Float = 1.0
        var scaleY: Float = 1.0
        var resizeAspect: Float = 1.0
        
        internalBounds = self.bounds
        textureWidth = width
        textureHeight = height
        textureMirroring = mirroring
        textureRotation = rotation
        
        if textureWidth > 0 && textureHeight > 0 {
            switch textureRotation {
            case .rotate0Degrees, .rotate180Degrees:
                scaleX = Float(internalBounds.width / CGFloat(textureWidth))
                scaleY = Float(internalBounds.height / CGFloat(textureHeight))
                
            case .rotate90Degrees, .rotate270Degrees:
                scaleX = Float(internalBounds.width / CGFloat(textureHeight))
                scaleY = Float(internalBounds.height / CGFloat(textureWidth))
            }
        }
        // Resize aspect ratio.
        resizeAspect = min(scaleX, scaleY)
        if scaleX < scaleY {
            scaleY = scaleX / scaleY
            scaleX = 1.0
        } else {
            scaleX = scaleY / scaleX
            scaleY = 1.0
        }
        
        if textureMirroring {
            scaleX *= -1.0
        }
        
        // Vertex coordinate takes the gravity into account.
        let vertexData: [Float] = [
            -scaleX, -scaleY,
            +scaleX, -scaleY,
            -scaleX, +scaleY,
            +scaleX, +scaleY,
        ]
        vertexCoordinateBuffer = device!.makeBuffer(bytes: vertexData, length: vertexData.count * MemoryLayout<Float>.size, options: [])
        
        // Texture coordinate takes the rotation into account.
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
        
//        // Calculate the transform from texture coordinates to view coordinates
//        var transform = CGAffineTransform.identity
//        if textureMirroring {
//            transform = transform.concatenating(CGAffineTransform(scaleX: -1, y: 1))
//            transform = transform.concatenating(CGAffineTransform(translationX: CGFloat(textureWidth), y: 0))
//        }
//
//        switch textureRotation {
//        case .rotate0Degrees:
//            transform = transform.concatenating(CGAffineTransform(rotationAngle: CGFloat(0)))
//
//        case .rotate180Degrees:
//            transform = transform.concatenating(CGAffineTransform(rotationAngle: CGFloat(Double.pi)))
//            transform = transform.concatenating(CGAffineTransform(translationX: CGFloat(textureWidth), y: CGFloat(textureHeight)))
//
//        case .rotate90Degrees:
//            transform = transform.concatenating(CGAffineTransform(rotationAngle: CGFloat(Double.pi) / 2))
//            transform = transform.concatenating(CGAffineTransform(translationX: CGFloat(textureHeight), y: 0))
//
//        case .rotate270Degrees:
//            transform = transform.concatenating(CGAffineTransform(rotationAngle: 3 * CGFloat(Double.pi) / 2))
//            transform = transform.concatenating(CGAffineTransform(translationX: 0, y: CGFloat(textureWidth)))
//        }
//        
//        transform = transform.concatenating(CGAffineTransform(scaleX: CGFloat(resizeAspect), y: CGFloat(resizeAspect)))
//        let tranformRect = CGRect(origin: .zero, size: CGSize(width: textureWidth, height: textureHeight)).applying(transform)
//        let xShift = (internalBounds.size.width - tranformRect.size.width) / 2
//        let yShift = (internalBounds.size.height - tranformRect.size.height) / 2
//        transform = transform.concatenating(CGAffineTransform(translationX: xShift, y: yShift))
//        textureTranform = transform.inverted()
    }
}
