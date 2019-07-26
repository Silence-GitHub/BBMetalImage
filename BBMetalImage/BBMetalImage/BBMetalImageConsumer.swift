//
//  BBMetalImageConsumer.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/8/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import CoreMedia
import AVFoundation

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

/// Defines texture behaviors
public protocol BBMetalTexture {
    /// Metal texture
    var metalTexture: MTLTexture { get set }
    
    /// Sample time of the metal texture.
    /// If the metal texture is used as static image, the sample time is nil.
    /// If the metal texture is used as video frame, the sample time should not be nil.
    var sampleTime: CMTime? { get }
    
    /// Camera position.
    /// Nil if unknown or image does not come from camera.
    var cameraPosition: AVCaptureDevice.Position? { get }
}

/// Defines audio consumer behaviors
public protocol BBMetalAudioConsumer: AnyObject {
    /// Receives a sample buffer
    ///
    /// - Parameter sampleBuffer: audio sample buffer to receive
    func newAudioSampleBufferAvailable(_ sampleBuffer: CMSampleBuffer)
}

struct BBMetalDefaultTexture: BBMetalTexture {
    var metalTexture: MTLTexture
    let sampleTime: CMTime?
    let cameraPosition: AVCaptureDevice.Position?
    let cvMetalTexture: CVMetalTexture? // Hold CVMetalTexture to prevent stuttering. https://stackoverflow.com/questions/43550769/holding-onto-a-mtltexture-from-a-cvimagebuffer-causes-stuttering
    
    init(metalTexture: MTLTexture,
         sampleTime: CMTime? = nil,
         cameraPosition: AVCaptureDevice.Position? = nil,
         cvMetalTexture: CVMetalTexture? = nil) {
        self.metalTexture = metalTexture
        self.sampleTime = sampleTime
        self.cameraPosition = cameraPosition
        self.cvMetalTexture = cvMetalTexture
    }
}

struct BBMetalVideoTextureItem {
    let metalTexture: MTLTexture
    let cvMetalTexture: CVMetalTexture
}

// For simulator compile
#if targetEnvironment(simulator)
typealias CVMetalTexture = AnyClass
typealias CVMetalTextureCache = AnyClass
#endif
