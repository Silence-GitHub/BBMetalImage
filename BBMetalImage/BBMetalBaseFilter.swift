//
//  BBMetalBaseFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/1/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

public protocol BBMetalImageSource: AnyObject {
    func add(_ consumer: BBMetalImageConsumer, at index: Int)
    func remove(_ consumer: BBMetalImageConsumer)
}

public protocol BBMetalImageConsumer: AnyObject {
    func add(_ source: BBMetalImageSource)
    func remove(_ source: BBMetalImageSource)
    func newTextureAvailable(_ texture: MTLTexture, from source: BBMetalImageSource)
}

public struct BBMetalWeakImageSource {
    weak var source: BBMetalImageSource?
    var texture: MTLTexture?
    
    init(source: BBMetalImageSource) { self.source = source }
}

public class BBMetalBaseFilter {
    public private(set) var consumers: [BBMetalImageConsumer]
    public private(set) var sources: [BBMetalWeakImageSource]
    public let name: String
    public let computePipeline: MTLComputePipelineState
    public private(set) var outputTexture: MTLTexture!
    public var threadgroupSize: MTLSize { didSet { threadgroupCount = nil } }
    public var threadgroupCount: MTLSize?
    
    init(kernelFunctionName: String) {
        consumers = []
        sources = []
        name = kernelFunctionName
        
        let library = BBMetalDevice.sharedDevice.makeDefaultLibrary()!
        let kernelFunction = library.makeFunction(name: kernelFunctionName)!
        computePipeline = try! BBMetalDevice.sharedDevice.makeComputePipelineState(function: kernelFunction)
        threadgroupSize = MTLSize(width: 16, height: 16, depth: 1)
    }
}

extension BBMetalBaseFilter: BBMetalImageSource {
    @discardableResult
    public func add<T: BBMetalImageConsumer>(_ consumer: T) -> T {
        consumers.append(consumer)
        consumer.add(self)
        return consumer
    }
    
    public func add(_ consumer: BBMetalImageConsumer, at index: Int) {
        consumers.insert(consumer, at: index)
        consumer.add(self)
    }
    
    public func remove(_ consumer: BBMetalImageConsumer) {
        if let index = consumers.firstIndex(where: { $0 === consumer }) {
            consumers.remove(at: index)
            consumer.remove(self)
        }
    }
}

extension BBMetalBaseFilter: BBMetalImageConsumer {
    public func add(_ source: BBMetalImageSource) {
        sources.append(BBMetalWeakImageSource(source: source))
    }
    
    public func remove(_ source: BBMetalImageSource) {
        if let index = sources.firstIndex(where: { $0.source === source }) {
            sources.remove(at: index)
        }
    }
    
    public func newTextureAvailable(_ texture: MTLTexture, from source: BBMetalImageSource) {
        // Check whether all input textures are ready
        var foundSource = false
        for i in 0..<sources.count {
            if sources[i].source === source {
                sources[i].texture = texture
                foundSource = true
            } else if sources[i].texture == nil {
                if foundSource { return }
            }
        }
        
        // Check whether output texture has the same size as input texture
        if outputTexture == nil ||
            outputTexture!.width != texture.width ||
            outputTexture!.height != texture.height {
            let descriptor = MTLTextureDescriptor()
            descriptor.pixelFormat = .rgba8Unorm
            descriptor.width = texture.width
            descriptor.height = texture.height
            descriptor.usage = [.shaderRead, .shaderWrite]
            if let output = BBMetalDevice.sharedDevice.makeTexture(descriptor: descriptor) {
                outputTexture = output
            } else {
                return
            }
        }
        
        // Update thread group count if needed
        if threadgroupCount == nil {
            threadgroupCount = MTLSize(width: (texture.width + threadgroupSize.width - 1) / threadgroupSize.width,
                                       height: (texture.height + threadgroupSize.height - 1) / threadgroupSize.height,
                                       depth: 1)
        }
        
        // Render image to output texture
        guard let commandBuffer = BBMetalDevice.sharedCommandQueue.makeCommandBuffer(),
            let encoder = commandBuffer.makeComputeCommandEncoder() else { return }
        
        encoder.label = name
        encoder.setComputePipelineState(computePipeline)
        for i in 0..<sources.count { encoder.setTexture(sources[i].texture, index: i) }
        encoder.setTexture(outputTexture, index: sources.count)
        updateParameters(forComputeCommandEncoder: encoder)
        encoder.dispatchThreadgroups(threadgroupCount!, threadsPerThreadgroup: threadgroupSize)
        encoder.endEncoding()
        
        commandBuffer.commit()
        
        // Clear old input texture
        for i in 0..<sources.count { sources[i].texture = nil }
        
        // Transmit output texture to image consumers
        for consumer in consumers { consumer.newTextureAvailable(outputTexture, from: self) }
    }
    
    @objc func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        fatalError("\(#function) must be overridden by subclass")
    }
}
