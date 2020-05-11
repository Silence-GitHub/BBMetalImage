//
//  BBMetalExclusionBlendFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Applies an exclusion blend of two images
public class BBMetalExclusionBlendFilter: BBMetalBaseFilter {
    public init() { super.init(kernelFunctionName: "exclusionBlendKernel") }
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {}
}
