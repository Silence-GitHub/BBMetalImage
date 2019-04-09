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
    private lazy var renderPipeline: MTLRenderPipelineState = {
        let library = try! device!.makeDefaultLibrary(bundle: Bundle(for: BBMetalView.self))
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "TexturePipeline"
        descriptor.vertexFunction = library.makeFunction(name: "vertexPassThrough")!
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentPassThrough")!
        descriptor.colorAttachments[0].pixelFormat = colorPixelFormat
        return try! metalDevice.makeRenderPipelineState(descriptor: descriptor)
    }()
    
    private lazy var vertexCoordinateBuffer: MTLBuffer = {
        return metalDevice.makeBuffer(bytes: &vertexCoordinate,
                                      length: MemoryLayout<Float>.size * vertexCoordinate.count,
                                      options: .storageModeShared)!
    }()
    
    private lazy var textureCoordinateBuffer: MTLBuffer = {
        return metalDevice.makeBuffer(bytes: &textureCoordinate,
                                      length: MemoryLayout<Float>.size * textureCoordinate.count,
                                      options: .storageModeShared)!
    }()
    
    private var metalDevice: MTLDevice {
        var d = device
        if d == nil {
            d = BBMetalDevice.sharedDevice
            device =  d
        }
        return d!
    }
}

extension BBMetalView: BBMetalImageConsumer {
    public func add(source: BBMetalImageSource) {}
    public func remove(source: BBMetalImageSource) {}
    
    public func newTextureAvailable(_ texture: MTLTexture, from source: BBMetalImageSource) {
        guard let drawable = currentDrawable,
            let descriptor = currentRenderPassDescriptor,
            let commandBuffer = BBMetalDevice.sharedCommandQueue.makeCommandBuffer(),
            let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else { return }
        
        encoder.label = "RenderPassThrough"
        
        // Set the region of the drawable to which we'll draw
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
        
        encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: vertexCoordinate.count)
        
        encoder.endEncoding()
        
        commandBuffer.present(drawable)
        
        commandBuffer.commit()
    }
}
