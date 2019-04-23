//
//  BBMetalBaseFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/1/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

public struct BBMetalWeakImageSource {
    public weak var source: BBMetalImageSource?
    public var texture: MTLTexture?
    
    public init(source: BBMetalImageSource) { self.source = source }
}

/// A base filter processing texture. Subclass this class. Do not create an instance using the class directly.
open class BBMetalBaseFilter: BBMetalImageSource, BBMetalImageConsumer {
    /// Image consumers
    public var consumers: [BBMetalImageConsumer] {
        lock.wait()
        let c = _consumers
        lock.signal()
        return c
    }
    private var _consumers: [BBMetalImageConsumer]
    
    /// Image sources
    public var sources: [BBMetalWeakImageSource] {
        lock.wait()
        let s = _sources
        lock.signal()
        return s
    }
    public private(set) var _sources: [BBMetalWeakImageSource]
    
    /// Filter name
    public let name: String
    
    /// Output texture containing last processing result
    public var outputTexture: MTLTexture? {
        lock.wait()
        let o = _outputTexture
        lock.signal()
        return o
    }
    public private(set) var _outputTexture: MTLTexture?
    
    private let threadgroupSize: MTLSize
    private var threadgroupCount: MTLSize?
    
    /// Whether to synchronously wait for the execution of the Metal command buffer to complete
    public var runSynchronously: Bool {
        get {
            lock.wait()
            let r = _runSynchronously
            lock.signal()
            return r
        }
        set {
            lock.wait()
            _runSynchronously = newValue
            lock.signal()
        }
    }
    private var _runSynchronously: Bool
    
    /// Whether to use `MPSKernel` or not
    public let useMPSKernel: Bool
    
    private var computePipeline: MTLComputePipelineState!
    private var completions: [(MTLCommandBuffer) -> Void]
    private let lock: DispatchSemaphore
    
    public init(kernelFunctionName: String, useMPSKernel: Bool = false) {
        _consumers = []
        _sources = []
        name = kernelFunctionName
        self.useMPSKernel = useMPSKernel
        
        if !useMPSKernel,
            let library = try? BBMetalDevice.sharedDevice.makeDefaultLibrary(bundle: Bundle(for: BBMetalBaseFilter.self)),
            let kernelFunction = library.makeFunction(name: kernelFunctionName) {
            computePipeline = try? BBMetalDevice.sharedDevice.makeComputePipelineState(function: kernelFunction)
        }
        threadgroupSize = MTLSize(width: 16, height: 16, depth: 1)
        _runSynchronously = false
        completions = []
        lock = DispatchSemaphore(value: 1)
    }
    
    /// Registers a block of code that is called immediately after the device has completed the execution of the Metal command buffer
    ///
    /// - Parameter handler: block to register
    public func addCompletedHandler(_ handler: @escaping (MTLCommandBuffer) -> Void) {
        lock.wait()
        completions.append(handler)
        lock.signal()
    }
    
    /// Gets a processed image synchronously
    ///
    /// - Parameter images: image to process
    /// - Returns: a processed image, or nil if fail processing
    public func filteredImage(with images: UIImage...) -> UIImage? {
        let sources = images.map { (image) -> BBMetalStaticImageSource in
            let imageSource = BBMetalStaticImageSource(image: image)
            imageSource.add(consumer: self)
            return imageSource
        }
        runSynchronously = true
        for source in sources { source.transmitTexture() }
        return outputTexture?.bb_image
    }

    // MARK: - BBMetalImageSource
    
    @discardableResult
    public func add<T: BBMetalImageConsumer>(consumer: T) -> T {
        lock.wait()
        _consumers.append(consumer)
        lock.signal()
        consumer.add(source: self)
        return consumer
    }
    
    public func add(consumer: BBMetalImageConsumer, at index: Int) {
        lock.wait()
        _consumers.insert(consumer, at: index)
        lock.signal()
        consumer.add(source: self)
    }
    
    public func remove(consumer: BBMetalImageConsumer) {
        lock.wait()
        if let index = _consumers.firstIndex(where: { $0 === consumer }) {
            _consumers.remove(at: index)
            lock.signal()
            consumer.remove(source: self)
        } else {
            lock.signal()
        }
    }
    
    public func removeAllConsumers() {
        lock.wait()
        let consumers = _consumers
        _consumers.removeAll()
        lock.signal()
        for consumer in consumers {
            consumer.remove(source: self)
        }
    }

    // MARK: - BBMetalImageConsumer
    
    public func add(source: BBMetalImageSource) {
        lock.wait()
        _sources.append(BBMetalWeakImageSource(source: source))
        lock.signal()
    }
    
    public func remove(source: BBMetalImageSource) {
        lock.wait()
        if let index = _sources.firstIndex(where: { $0.source === source }) {
            _sources.remove(at: index)
        }
        lock.signal()
    }
    
    public func newTextureAvailable(_ texture: MTLTexture, from source: BBMetalImageSource) {
        lock.wait()
        
        // Check whether all input textures are ready
        var foundSource = false
        var empty = false
        for i in 0..<_sources.count {
            if _sources[i].source === source {
                _sources[i].texture = texture
                foundSource = true
            } else if _sources[i].texture == nil {
                if foundSource {
                    lock.signal()
                    return
                }
                empty = true
            }
        }
        if !foundSource || empty {
            lock.signal()
            return
        }
        
        // Check whether output texture has the same size as input texture
        let firstTexture = _sources.first!.texture!
        let outputSize = outputTextureSize(withInputTextureSize: BBMetalIntSize(width: firstTexture.width, height: firstTexture.height))
        if _outputTexture == nil ||
            _outputTexture!.width != outputSize.width ||
            _outputTexture!.height != outputSize.height {
            let descriptor = MTLTextureDescriptor()
            descriptor.pixelFormat = .rgba8Unorm
            descriptor.width = outputSize.width
            descriptor.height = outputSize.height
            descriptor.usage = [.shaderRead, .shaderWrite]
            if let output = BBMetalDevice.sharedDevice.makeTexture(descriptor: descriptor) {
                _outputTexture = output
            } else {
                lock.signal()
                return
            }
            threadgroupCount = nil
        }
        
        // Render image to output texture
        guard let commandBuffer = BBMetalDevice.sharedCommandQueue.makeCommandBuffer() else { return }
        commandBuffer.label = name + "Command"
        
        if useMPSKernel {
            encodeMPSKernel(into: commandBuffer)
        } else {
            // Update thread group count if needed
            if threadgroupCount == nil {
                threadgroupCount = MTLSize(width: (outputSize.width + threadgroupSize.width - 1) / threadgroupSize.width,
                                           height: (outputSize.height + threadgroupSize.height - 1) / threadgroupSize.height,
                                           depth: 1)
            }
            
            guard let encoder = commandBuffer.makeComputeCommandEncoder() else { return }
            
            for completion in completions { commandBuffer.addCompletedHandler(completion) }
            
            encoder.label = name + "Encoder"
            encoder.setComputePipelineState(computePipeline)
            encoder.setTexture(_outputTexture, index: 0)
            for i in 0..<_sources.count { encoder.setTexture(_sources[i].texture, index: i + 1) }
            updateParameters(forComputeCommandEncoder: encoder)
            encoder.dispatchThreadgroups(threadgroupCount!, threadsPerThreadgroup: threadgroupSize)
            encoder.endEncoding()
        }
        
        commandBuffer.commit()
        if _runSynchronously { commandBuffer.waitUntilCompleted() }
        
        // Clear old input texture
        for i in 0..<_sources.count { _sources[i].texture = nil }
        
        let consumers = _consumers
        lock.signal()
        
        // Transmit output texture to image consumers
        for consumer in consumers { consumer.newTextureAvailable(_outputTexture!, from: self) }
    }
    
    /// Calcutes the ouput texture size.
    /// Returns the input texture size by default.
    /// Override the method if needed.
    ///
    /// - Parameter inputSize: input texture size
    /// - Returns: output texture size
    open func outputTextureSize(withInputTextureSize inputSize: BBMetalIntSize) -> BBMetalIntSize {
        return inputSize
    }
    
    /// Encodes a kernel into a command buffer.
    /// Override the method if using MPSKernel.
    ///
    /// - Parameter commandBuffer: command buffer to use
    open func encodeMPSKernel(into commandBuffer: MTLCommandBuffer) {
        fatalError("\(#function) must be overridden by subclass")
    }
    
    /// Updates parameters for the compute command encoder.
    /// Override the method to set bytes or other paramters for the compute command encoder.
    ///
    /// - Parameter encoder: compute command encoder to use
    open func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        fatalError("\(#function) must be overridden by subclass")
    }
}
