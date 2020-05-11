//
//  BBMetalSwirlFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/11/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Creates a swirl distortion on the image
public class BBMetalSwirlFilter: BBMetalBaseFilter {
    /// The center of the image (in normalized coordinates from 0 ~ 1.0) about which to twist, with a default of (0.5, 0.5)
    public var center: BBMetalPosition
    /// The radius from the center to apply the distortion, with a default of 0.5
    public var radius: Float
    /// The amount of twist to apply to the image, with a default of 1.0
    public var angle: Float
    
    public init(center: BBMetalPosition = .center, radius: Float = 0.5, angle: Float = 1) {
        self.center = center
        self.radius = radius
        self.angle = angle
        super.init(kernelFunctionName: "swirlKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&center, length: MemoryLayout<BBMetalPosition>.size, index: 0)
        encoder.setBytes(&radius, length: MemoryLayout<Float>.size, index: 1)
        encoder.setBytes(&angle, length: MemoryLayout<Float>.size, index: 2)
    }
}
