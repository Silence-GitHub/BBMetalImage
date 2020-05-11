//
//  BBMetalLuminosityBlendFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/6/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Applies a luminosity blend of two images
public class BBMetalLuminosityBlendFilter: BBMetalBaseFilter {
    public init() { super.init(kernelFunctionName: "luminosityBlendKernel") }
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {}
}
