//
//  BBMetalPosterizeFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/11/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// This reduces the color dynamic range into the number of steps specified, leading to a cartoon-like simple shading of the image
public class BBMetalPosterizeFilter: BBMetalBaseFilter {
    /// The number of color levels to reduce the image space to. This ranges from 1 to 256, with a default of 10
    public var colorLevels: Float
    
    public init(colorLevels: Float = 10) {
        self.colorLevels = colorLevels
        super.init(kernelFunctionName: "posterizeKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&colorLevels, length: MemoryLayout<Float>.size, index: 0)
    }
}
