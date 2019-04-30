//
//  BBMetalImageConsumer.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/8/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import CoreMedia

/// Defines image consumer behaviors
public protocol BBMetalImageConsumer: AnyObject {
    /// Adds an image source to provide the input texture
    ///
    /// - Parameter source: image source object to add
    func add(source: BBMetalImageSource)
    
    /// Removes the image source
    ///
    /// - Parameter source: image source object to remove
    func remove(source: BBMetalImageSource)
    
    /// Receives a new texture from an image source
    ///
    /// - Parameters:
    ///   - texture: new texture received
    ///   - source: image source object providing the new texture
    func newTextureAvailable(_ texture: BBMetalTexture, from source: BBMetalImageSource)
}

public protocol BBMetalTexture {
    var metalTexture: MTLTexture { get }
    var sampleTime: CMTime? { get }
}

struct BBMetalDefaultTexture: BBMetalTexture {
    let metalTexture: MTLTexture
    let sampleTime: CMTime?
    
    init(metalTexture: MTLTexture, sampleTime: CMTime? = nil) {
        self.metalTexture = metalTexture
        self.sampleTime = sampleTime
    }
}
