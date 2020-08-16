//
//  BBMetalPinchFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 8/16/20.
//  Copyright © 2020 Kaibo Lu. All rights reserved.
//

import UIKit

/// Creates a pinch distortion of the image
public class BBMetalPinchFilter: BBMetalBaseFilter {
    /// The center of the image (in normalized coordinates from 0 - 1.0) about which to distort, with a default of (0.5, 0.5)
    public var center: BBMetalPosition
    
    /// The radius from the center to apply the distortion, with a default of 0.5
    public var radius: Float
    
    /// The amount of distortion to apply, from -2.0 to 2.0, with a default of 0.5
    public var scale: Float
    
    public init(center: BBMetalPosition = .center, radius: Float = 0.5, scale: Float = 0.5) {
        self.center = center
        self.radius = radius
        self.scale = scale
        super.init(kernelFunctionName: "pinchKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&center, length: MemoryLayout<BBMetalPosition>.size, index: 0)
        encoder.setBytes(&radius, length: MemoryLayout<Float>.size, index: 1)
        encoder.setBytes(&scale, length: MemoryLayout<Float>.size, index: 2)
    }
}
