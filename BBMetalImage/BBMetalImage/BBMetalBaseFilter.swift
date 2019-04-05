//
//  BBMetalBaseFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/1/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

public protocol BBMetalImageSource: AnyObject {
    func add<T: BBMetalImageConsumer>(consumer: T) -> T
    func add(consumer: BBMetalImageConsumer, at index: Int)
    func remove(consumer: BBMetalImageConsumer)
}

public protocol BBMetalImageConsumer: AnyObject {
    func add(source: BBMetalImageSource)
    func remove(source: BBMetalImageSource)
    func newTextureAvailable(_ texture: MTLTexture, from source: BBMetalImageSource)
}

public struct BBMetalWeakImageSource {
    public weak var source: BBMetalImageSource?
    public var texture: MTLTexture?
    
    public init(source: BBMetalImageSource) { self.source = source }
}

public class BBMetalBaseFilter {
    public private(set) var consumers: [BBMetalImageConsumer]
    public private(set) var sources: [BBMetalWeakImageSource]
    public let name: String
    public private(set) var outputTexture: MTLTexture?
    public var threadgroupSize: MTLSize { didSet { threadgroupCount = nil } }
    public var threadgroupCount: MTLSize?
    public var runSynchronously: Bool
    public let useMPSKernel: Bool
    
    private var computePipeline: MTLComputePipelineState!
    private var completions: [(MTLCommandBuffer) -> Void]
    
    public init(kernelFunctionName: String, useMPSKernel: Bool = false) {
        consumers = []
        sources = []
        name = kernelFunctionName
        self.useMPSKernel = useMPSKernel
        
        if !useMPSKernel {
            let library = try! BBMetalDevice.sharedDevice.makeDefaultLibrary(bundle: Bundle(for: BBMetalBaseFilter.self))
            let kernelFunction = library.makeFunction(name: kernelFunctionName)!
            computePipeline = try! BBMetalDevice.sharedDevice.makeComputePipelineState(function: kernelFunction)
        }
        threadgroupSize = MTLSize(width: 16, height: 16, depth: 1)
        runSynchronously = false
        completions = []
    }
    
    public func addCompletedHandler(_ handler: @escaping (MTLCommandBuffer) -> Void) {
        completions.append(handler)
    }
}

extension BBMetalBaseFilter: BBMetalImageSource {
    @discardableResult
    public func add<T: BBMetalImageConsumer>(consumer: T) -> T {
        consumers.append(consumer)
        consumer.add(source: self)
        return consumer
    }
    
    public func add(consumer: BBMetalImageConsumer, at index: Int) {
        consumers.insert(consumer, at: index)
        consumer.add(source: self)
    }
    
    public func remove(consumer: BBMetalImageConsumer) {
        if let index = consumers.firstIndex(where: { $0 === consumer }) {
            consumers.remove(at: index)
            consumer.remove(source: self)
        }
    }
}

extension BBMetalBaseFilter: BBMetalImageConsumer {
    public func add(source: BBMetalImageSource) {
        sources.append(BBMetalWeakImageSource(source: source))
    }
    
    public func remove(source: BBMetalImageSource) {
        if let index = sources.firstIndex(where: { $0.source === source }) {
            sources.remove(at: index)
        }
    }
    
    public func newTextureAvailable(_ texture: MTLTexture, from source: BBMetalImageSource) {
        // Check whether all input textures are ready
        var foundSource = false
        var empty = false
        for i in 0..<sources.count {
            if sources[i].source === source {
                sources[i].texture = texture
                foundSource = true
            } else if sources[i].texture == nil {
                if foundSource { return }
                empty = true
            }
        }
        if !foundSource || empty { return }
        
        // Check whether output texture has the same size as input texture
        let firstTexture = sources.first!.texture!
        if outputTexture == nil ||
            outputTexture!.width != firstTexture.width ||
            outputTexture!.height != firstTexture.height {
            let descriptor = MTLTextureDescriptor()
            descriptor.pixelFormat = .rgba8Unorm
            descriptor.width = firstTexture.width
            descriptor.height = firstTexture.height
            descriptor.usage = [.shaderRead, .shaderWrite]
            if let output = BBMetalDevice.sharedDevice.makeTexture(descriptor: descriptor) {
                outputTexture = output
            } else {
                return
            }
        }
        
        // Update thread group count if needed
        if threadgroupCount == nil {
            threadgroupCount = MTLSize(width: (firstTexture.width + threadgroupSize.width - 1) / threadgroupSize.width,
                                       height: (firstTexture.height + threadgroupSize.height - 1) / threadgroupSize.height,
                                       depth: 1)
        }
        
        // Render image to output texture
        guard let commandBuffer = BBMetalDevice.sharedCommandQueue.makeCommandBuffer() else { return }
        
        if useMPSKernel {
            encodeMPSKernel(into: commandBuffer)
        } else {
            guard let encoder = commandBuffer.makeComputeCommandEncoder() else { return }
            
            for completion in completions { commandBuffer.addCompletedHandler(completion) }
            
            encoder.label = name
            encoder.setComputePipelineState(computePipeline)
            encoder.setTexture(outputTexture, index: 0)
            for i in 0..<sources.count { encoder.setTexture(sources[i].texture, index: i + 1) }
            updateParameters(forComputeCommandEncoder: encoder)
            encoder.dispatchThreadgroups(threadgroupCount!, threadsPerThreadgroup: threadgroupSize)
            encoder.endEncoding()
        }
        
        commandBuffer.commit()
        if runSynchronously { commandBuffer.waitUntilCompleted() }
        
        // Clear old input texture
        for i in 0..<sources.count { sources[i].texture = nil }
        
        // Transmit output texture to image consumers
        for consumer in consumers { consumer.newTextureAvailable(outputTexture!, from: self) }
    }
    
    @objc func encodeMPSKernel(into commandBuffer: MTLCommandBuffer) {
        fatalError("\(#function) must be overridden by subclass")
    }
    
    @objc func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        fatalError("\(#function) must be overridden by subclass")
    }
}
