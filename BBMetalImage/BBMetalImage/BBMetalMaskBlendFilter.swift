//
//  BBMetalMaskBlendFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/6/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Masks one image using another
public class BBMetalMaskBlendFilter: BBMetalBaseFilter {
    public init() { super.init(kernelFunctionName: "maskBlendKernel") }
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {}
}
