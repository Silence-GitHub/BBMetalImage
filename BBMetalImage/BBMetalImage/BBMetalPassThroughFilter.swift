//
//  BBMetalPassThroughFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 9/18/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Pass through filter passes the same texture from image source to image consumer. Use pass through filter to setup the filter chain for custom filter group.
public class BBMetalPassThroughFilter: BBMetalBaseFilter {
    /// Whether to create a new texture. False by default for performance.
    public let createTexture: Bool
    
    public init(createTexture: Bool = false) {
        self.createTexture = createTexture
        super.init(kernelFunctionName: "passThroughKernel")
    }
    
    public override func newTextureAvailable(_ texture: BBMetalTexture, from source: BBMetalImageSource) {
        if createTexture {
            super.newTextureAvailable(texture, from: source)
        } else {
            // Transmit output texture to image consumers
            for consumer in consumers { consumer.newTextureAvailable(texture, from: self) }
        }
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {}
}
