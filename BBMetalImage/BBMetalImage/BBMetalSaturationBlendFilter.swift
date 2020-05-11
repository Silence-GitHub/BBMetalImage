//
//  BBMetalSaturationBlendFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/6/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Applies a saturation blend of two images
public class BBMetalSaturationBlendFilter: BBMetalBaseFilter {
    public init() { super.init(kernelFunctionName: "saturationBlendKernel") }
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {}
}
