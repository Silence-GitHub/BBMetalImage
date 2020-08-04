//
//  BBMetalMultipleImageSource.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 7/29/20.
//  Copyright © 2020 Kaibo Lu. All rights reserved.
//

import CoreMedia
import UIKit

/// An image source providing multiple-image texture
public class BBMetalMultipleImageSource {
    /// Image consumers
    public var consumers: [BBMetalImageConsumer] {
        lock.wait()
        let c = _consumers
        lock.signal()
        return c
    }
    private var _consumers: [BBMetalImageConsumer] = []
    
    private var images: [UIImage]?
    private var cgimages: [CGImage]?
    private var imageDatas: [Data]?
    private var textures: [MTLTexture]?
    
    public let sourceCount: Int

    private let hasAllTextures: Bool
    private var textureCache: [Int: MTLTexture] = [:]
    
    private let lock = DispatchSemaphore(value: 1)
    
    deinit {
        lock.wait()
        NotificationCenter.default.removeObserver(self)
        lock.signal()
    }
    
    public init(images: [UIImage]) {
        self.images = images
        self.sourceCount = images.count
        self.hasAllTextures = false
        setup()
    }
    
    public init(cgimages: [CGImage]) {
        self.cgimages = cgimages
        self.sourceCount = cgimages.count
        self.hasAllTextures = false
        setup()
    }
    
    public init(imageDatas: [Data]) {
        self.imageDatas = imageDatas
        self.sourceCount = imageDatas.count
        self.hasAllTextures = false
        setup()
    }
    
    public init(textures: [MTLTexture]) {
        self.textures = textures
        self.sourceCount = textures.count
        self.hasAllTextures = true
        setup()
    }
    
    private func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(clearCache), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    /// Transmits texture to image consumers
    /// - Parameters:
    ///   - index: texture index
    ///   - sampleTime: frame sample time, nil by default
    public func transmitTexture(at index: Int, sampleTime: CMTime? = nil) {
        lock.wait()
        guard let texture = texture(at: index) else {
            lock.signal()
            return
        }
        let consumers = _consumers
        lock.signal()
        preloadTextureCache(from: index)
        let output = BBMetalDefaultTexture(metalTexture: texture, sampleTime: sampleTime)
        for consumer in consumers { consumer.newTextureAvailable(output, from: self) }
    }
    
    private func texture(at index: Int) -> MTLTexture? {
        if hasAllTextures { return textures![index] }
        if let texture = textureCache[index] { return texture }
        var texture = images?[index].bb_metalTexture
        if texture == nil { texture = cgimages?[index].bb_metalTexture }
        if texture == nil { texture = imageDatas?[index].bb_metalTexture }
        textureCache[index] = texture
        return texture
    }
    
    private func preloadTextureCache(from index: Int) {
        if hasAllTextures { return }
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.lock.wait()
            _ = self.texture(at: (index + 1) % self.sourceCount)
            self.lock.signal()
        }
    }
    
    /// Preloads all textures synchronously
    public func preloadAllTextures() {
        if hasAllTextures { return }
        lock.wait()
        for i in 0..<sourceCount {
            _ = texture(at: i)
        }
        lock.signal()
    }
    
    /// Clears texture cache
    @objc public func clearCache() {
        lock.wait()
        textureCache.removeAll()
        lock.signal()
    }
}

extension BBMetalMultipleImageSource: BBMetalImageSource {
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
}
