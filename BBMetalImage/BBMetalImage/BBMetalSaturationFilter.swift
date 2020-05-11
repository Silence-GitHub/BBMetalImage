//
//  BBMetalSaturationFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/3/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Adjusts the saturation of an image
public class BBMetalSaturationFilter: BBMetalBaseFilter {
    /// The degree of saturation or desaturation to apply to the image (0.0 ~ 2.0, with 1.0 as the default)
    public var saturation: Float
    
    public init(saturation: Float = 1) {
        self.saturation = saturation
        super.init(kernelFunctionName: "saturationKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&saturation, length: MemoryLayout<Float>.size, index: 0)
    }
}
