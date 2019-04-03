//
//  BBMetalStaticImageSource.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/1/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit
import MetalKit

public class BBMetalStaticImageSource {
    public private(set) var consumers: [BBMetalImageConsumer] = []
    public private(set) var texture: MTLTexture?
    private let image: UIImage
    
    public init(image: UIImage) { self.image = image }
    
    public func transmitTexture() {
        if texture == nil { texture = image.bb_metalTexture }
        guard let texture = self.texture else { return }
        for consumer in consumers { consumer.newTextureAvailable(texture, from: self) }
    }
}

extension BBMetalStaticImageSource: BBMetalImageSource {
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

public extension UIImage {
    public var bb_metalTexture: MTLTexture? {
        if let cgimage = cgImage { return cgimage.bb_metalTexture }
        return nil
    }
}

public extension CGImage {
    public var bb_metalTexture: MTLTexture? {
        let loader = MTKTextureLoader(device: BBMetalDevice.sharedDevice)
        return try? loader.newTexture(cgImage: self, options: [MTKTextureLoader.Option.SRGB : false])
        /*
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
                                    space: CGColorSpaceCreateDeviceRGB(), // TODO: Use share color space
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
         */
    }
}

public extension Data {
    public var bb_metalTexture: MTLTexture? {
        let loader = MTKTextureLoader(device: BBMetalDevice.sharedDevice)
        return try? loader.newTexture(data: self, options: [MTKTextureLoader.Option.SRGB : false])
    }
}

public extension MTLTexture {
    public var bb_cgimage: CGImage? {
        let bytesPerPixel: Int = 4
        let bytesPerRow: Int = width * bytesPerPixel
        var data = [UInt8](repeating: 0, count: Int(width * height * bytesPerPixel))
        getBytes(&data, bytesPerRow: bytesPerRow, from: MTLRegionMake2D(0, 0, width, height), mipmapLevel: 0)
        let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue
        if let context = CGContext(data: &data,
                                   width: width,
                                   height: height,
                                   bitsPerComponent: 8,
                                   bytesPerRow: bytesPerRow,
                                   space: CGColorSpaceCreateDeviceRGB(),
                                   bitmapInfo: bitmapInfo) {
            return context.makeImage()
        }
        return nil
    }
    
    public var bb_image: UIImage? {
        if let sourceImage = bb_cgimage {
            return UIImage(cgImage: sourceImage)
        }
        return nil
    }
}
