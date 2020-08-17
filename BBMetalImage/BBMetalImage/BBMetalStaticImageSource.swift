//
//  BBMetalStaticImageSource.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/1/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import MetalKit

/// An image source providing static image texture
public class BBMetalStaticImageSource {
    /// Image consumers
    public var consumers: [BBMetalImageConsumer] {
        lock.wait()
        let c = _consumers
        lock.signal()
        return c
    }
    private var _consumers: [BBMetalImageConsumer] = []
    
    /// Texture from static image
    public var texture: MTLTexture? {
        lock.wait()
        let t = _texture
        lock.signal()
        return t
    }
    private var _texture: MTLTexture?
    
    private var currentTexture: MTLTexture? {
        if let texture = image?.bb_metalTexture { return texture }
        if let texture = cgimage?.bb_metalTexture { return texture }
        if let texture = imageData?.bb_metalTexture { return texture }
        return nil
    }
    
    private var image: UIImage?
    private var cgimage: CGImage?
    private var imageData: Data?
    
    private let lock = DispatchSemaphore(value: 1)
    
    public init(image: UIImage) { self.image = image }
    public init(cgimage: CGImage) { self.cgimage = cgimage }
    public init(imageData: Data) { self.imageData = imageData }
    public init(texture: MTLTexture) { _texture = texture }
    
    /// Transmits texture to image consumers
    public func transmitTexture() {
        lock.wait()
        if _texture == nil { _texture = currentTexture }
        guard let texture = _texture else {
            lock.signal()
            return
        }
        let consumers = _consumers
        lock.signal()
        let output = BBMetalDefaultTexture(metalTexture: texture)
        for consumer in consumers { consumer.newTextureAvailable(output, from: self) }
    }
    
    public func update(_ texture: MTLTexture) {
        lock.wait()
        reset()
        _texture = texture
        lock.signal()
    }
    
    public func update(_ image: UIImage) {
        lock.wait()
        reset()
        self.image = image
        lock.signal()
    }
    
    public func update(_ cgimage: CGImage) {
        lock.wait()
        reset()
        self.cgimage = cgimage
        lock.signal()
    }
    
    public func update(_ imageData: Data) {
        lock.wait()
        reset()
        self.imageData = imageData
        lock.signal()
    }
    
    private func reset() {
        _texture = nil
        image = nil
        cgimage = nil
        imageData = nil
    }
}

extension BBMetalStaticImageSource: BBMetalImageSource {
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

public extension UIImage {
    var bb_metalTexture: MTLTexture? {
        // To ensure image orientation is correct, redraw image if image orientation is not up
        // https://stackoverflow.com/questions/42098390/swift-png-image-being-saved-with-incorrect-orientation
        if let cgimage = bb_flattened?.cgImage { return cgimage.bb_metalTexture }
        return nil
    }
    
    private var bb_flattened: UIImage? {
        if imageOrientation == .up { return self }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}

public extension CGImage {
    var bb_metalTexture: MTLTexture? {
        let loader = MTKTextureLoader(device: BBMetalDevice.sharedDevice)
        if let texture = try? loader.newTexture(cgImage: self, options: [MTKTextureLoader.Option.SRGB : false]) {
            return texture
        }
        // Texture loader can not load image data to create texture
        // Draw image and create texture
        let descriptor = MTLTextureDescriptor()
        descriptor.pixelFormat = .rgba8Unorm
        descriptor.width = width
        descriptor.height = height
        descriptor.usage = .shaderRead
        let bytesPerRow: Int = width * 4
        let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue
        if let currentTexture = BBMetalDevice.sharedDevice.makeTexture(descriptor: descriptor),
            let context = CGContext(data: nil,
                                    width: width,
                                    height: height,
                                    bitsPerComponent: 8,
                                    bytesPerRow: bytesPerRow,
                                    space: BBMetalDevice.sharedColorSpace,
                                    bitmapInfo: bitmapInfo) {
            
            context.draw(self, in: CGRect(x: 0, y: 0, width: width, height: height))
            
            if let data = context.data {
                currentTexture.replace(region: MTLRegionMake3D(0, 0, 0, width, height, 1),
                                       mipmapLevel: 0,
                                       withBytes: data,
                                       bytesPerRow: bytesPerRow)
                
                return currentTexture
            }
        }
        return nil
    }
}

public extension Data {
    var bb_metalTexture: MTLTexture? {
        let loader = MTKTextureLoader(device: BBMetalDevice.sharedDevice)
        if let texture = try? loader.newTexture(data: self, options: [MTKTextureLoader.Option.SRGB : false]) { return texture }
        // If image orientation is not up, texture loader may not load texture from image data.
        // Create a UIImage from image data to get metal texture
        return UIImage(data: self)?.bb_metalTexture
    }
}

public extension MTLTexture {
    var bb_cgimage: CGImage? {
        // Data -> CGContext -> CGImage produces empty image on Xcode 11.5 release mode
        // Create CGImage with another way
        // Data -> CFData -> CGDataProvider -> CGImage
        let bytesPerPixel: Int = 4
        let bytesPerRow: Int = width * bytesPerPixel
        var data = [UInt8](repeating: 0, count: Int(width * height * bytesPerPixel))
        getBytes(&data, bytesPerRow: bytesPerRow, from: MTLRegionMake2D(0, 0, width, height), mipmapLevel: 0)
        let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue
        if let cfdata = CFDataCreate(kCFAllocatorDefault, &data, bytesPerRow * height),
            let dataProvider = CGDataProvider(data: cfdata),
            let cgimage = CGImage(width: width, height: height,
                                  bitsPerComponent: 8,
                                  bitsPerPixel: 32,
                                  bytesPerRow: bytesPerRow,
                                  space: BBMetalDevice.sharedColorSpace,
                                  bitmapInfo: CGBitmapInfo(rawValue: bitmapInfo),
                                  provider: dataProvider,
                                  decode: nil,
                                  shouldInterpolate: true,
                                  intent: .defaultIntent)
        {
            return cgimage
        }
        return nil
    }
    
    var bb_image: UIImage? {
        if let sourceImage = bb_cgimage {
            return UIImage(cgImage: sourceImage)
        }
        return nil
    }
}
