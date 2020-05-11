//
//  BBMetalLinearBurnBlendFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/6/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Applies a linear burn blend of two images
public class BBMetalLinearBurnBlendFilter: BBMetalBaseFilter {
    public init() { super.init(kernelFunctionName: "linearBurnBlendKernel") }
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {}
}
