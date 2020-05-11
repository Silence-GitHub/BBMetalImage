//
//  BBMetalMotionBlurFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Applies a directional motion blur to an image
public class BBMetalMotionBlurFilter: BBMetalBaseFilter {
    /// A multiplier for the blur size, ranging from 0.0 on up, with a default of 0.0
    public var blurSize: Float
    /// The angular direction of the blur, in degrees, with a default of 0.0
    public var blurAngle: Float
    
    public init(blurSize: Float = 0, blurAngle: Float = 0) {
        self.blurSize = blurSize
        self.blurAngle = blurAngle
        super.init(kernelFunctionName: "motionBlurKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&blurSize, length: MemoryLayout<Float>.size, index: 0)
        encoder.setBytes(&blurAngle, length: MemoryLayout<Float>.size, index: 1)
    }
}
