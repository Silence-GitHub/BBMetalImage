//
//  BBMetalColorBurnBlendFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Applies a color burn blend of two images
public class BBMetalColorBurnBlendFilter: BBMetalBaseFilter {
    public init() { super.init(kernelFunctionName: "colorBurnBlendKernel") }
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {}
}
