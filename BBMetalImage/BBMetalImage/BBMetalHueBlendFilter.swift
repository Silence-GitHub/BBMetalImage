//
//  BBMetalHueBlendFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Applies a hue blend of two images
public class BBMetalHueBlendFilter: BBMetalBaseFilter {
    public init() { super.init(kernelFunctionName: "hueBlendKernel") }
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {}
}
