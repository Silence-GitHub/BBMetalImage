//
//  BBMetalUISource.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 12/11/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit
import CoreMedia

/// UI Source capturing `UIView` snapshot and providing Metal texture
public class BBMetalUISource {
    /// The view to capture snapshot
    public let view: UIView
    
    /// Whether to update texture before transmitting texture.
    /// If true (default value), capture a view snapshot and update texture.
    /// If false, if there is old texture, it will be transmitted; If there is no texture, create one, capture a view snapshot and update texture.
    /// Capturing a view snapshot and updating texture costs time. If the view dose NOT change in a period, set this value to false for performance.
    public var shouldUpdateTexture: Bool = true
    
    /// Texture size in pixel. The default value is zero, and the texture size is the view pixel size (bounds.size * contentScaleFactor).
    public var textureSize: CGSize = .zero
    
    /// Valid texture size (nil if not valid)
    public var renderPixelSize: CGSize? {
        if textureSize.width >= 1 && textureSize.height >= 1 { return textureSize }
        let size = CGSize(width: view.bounds.width * view.contentScaleFactor, height: view.bounds.height * view.contentScaleFactor)
        if size.width >= 1 && size.height >= 1 { return size }
        return nil
    }
    
    /// Image consumers
    public var consumers: [BBMetalImageConsumer] {
        lock.wait()
        let c = _consumers
        lock.signal()
        return c
    }
    private var _consumers: [BBMetalImageConsumer] = []
    
    /// Metal texture for the view snapshot
    public var texture: MTLTexture? {
        lock.wait()
        let t = _texture
        lock.signal()
        return t
    }
    private var _texture: MTLTexture?
    
    private let lock = DispatchSemaphore(value: 1)
    
    public init(view: UIView) { self.view = view }
    
    /// Transmit texture to image consumers
    /// - Parameter sampleTime: sample time for this video frame
    public func transmitTexture(with sampleTime: CMTime) {
        lock.wait()
        
        guard let renderSize = renderPixelSize else {
            lock.signal()
            return
        }
        let renderWidth = Int(renderSize.width)
        let renderHeight = Int(renderSize.height)
        
        var shouldUpdate = shouldUpdateTexture
        
        if _texture == nil ||
            _texture!.width != renderWidth ||
            _texture!.height != renderHeight {

            let descriptor = MTLTextureDescriptor()
            descriptor.pixelFormat = .rgba8Unorm
            descriptor.width = renderWidth
            descriptor.height = renderHeight
            descriptor.usage = .shaderRead
            if let currentTexture = BBMetalDevice.sharedDevice.makeTexture(descriptor: descriptor) {
                _texture = currentTexture
            } else {
                lock.signal()
                return
            }
            
            shouldUpdate = true
        }
        
        if shouldUpdate {
            let bytesPerRow: Int = renderWidth * 4
            let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue
            guard let context = CGContext(data: nil,
                                          width: renderWidth,
                                          height: renderHeight,
                                          bitsPerComponent: 8,
                                          bytesPerRow: bytesPerRow,
                                          space: BBMetalDevice.sharedColorSpace,
                                          bitmapInfo: bitmapInfo) else {
                lock.signal()
                return print("Can not create CGContext for view snapshot")
            }
                
            UIGraphicsPushContext(context)
            defer { UIGraphicsPopContext() }
            
            context.interpolationQuality = .none
            context.translateBy(x: 0, y: renderSize.height)
            context.scaleBy(x: 1, y: -1)
            
            if !view.drawHierarchy(in: CGRect(origin: .zero, size: renderSize), afterScreenUpdates: false) {
                context.interpolationQuality = .default
                context.scaleBy(x: renderSize.width / view.bounds.width, y: renderSize.height / view.bounds.height)
                view.layer.render(in: context)
            }
            
            guard let data = context.data else {
                lock.signal()
                return print("Can not get CGContext data for view snapshot")
            }
            
            _texture!.replace(region: MTLRegionMake3D(0, 0, 0, renderWidth, renderHeight, 1),
                              mipmapLevel: 0,
                              withBytes: data,
                              bytesPerRow: bytesPerRow)
        }
        
        let consumers = _consumers
        
        lock.signal()
        
        let output = BBMetalDefaultTexture(metalTexture: _texture!, sampleTime: sampleTime)
        for consumer in consumers { consumer.newTextureAvailable(output, from: self) }
    }
}

extension BBMetalUISource: BBMetalImageSource {
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
