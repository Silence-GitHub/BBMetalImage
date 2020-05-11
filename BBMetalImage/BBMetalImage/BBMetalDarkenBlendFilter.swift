//
//  BBMetalDarkenBlendFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Blends two images by taking the minimum value of each color component between the images
public class BBMetalDarkenBlendFilter: BBMetalBaseFilter {
    public init() { super.init(kernelFunctionName: "darkenBlendKernel") }
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {}
}
