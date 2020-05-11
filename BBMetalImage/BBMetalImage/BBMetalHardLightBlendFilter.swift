//
//  BBMetalHardLightBlendFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Applies a hard light blend of two images
public class BBMetalHardLightBlendFilter: BBMetalBaseFilter {
    public init() { super.init(kernelFunctionName: "hardLightBlendKernel") }
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {}
}
