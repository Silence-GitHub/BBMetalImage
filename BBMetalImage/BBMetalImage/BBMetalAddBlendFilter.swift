//
//  BBMetalAddBlendFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Applies an additive blend of two images
public class BBMetalAddBlendFilter: BBMetalBaseFilter {
    public init() { super.init(kernelFunctionName: "addBlendKernel") }
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {}
}
