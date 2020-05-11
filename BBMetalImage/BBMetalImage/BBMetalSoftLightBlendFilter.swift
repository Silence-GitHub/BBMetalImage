//
//  BBMetalSoftLightBlendFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Applies a soft light blend of two images
public class BBMetalSoftLightBlendFilter: BBMetalBaseFilter {
    public init() { super.init(kernelFunctionName: "softLightBlendKernel") }
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {}
}
