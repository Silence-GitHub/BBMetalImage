//
//  BBMetalColorInversionFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/3/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Inverts the colors of an image
public class BBMetalColorInversionFilter: BBMetalBaseFilter {
    public init() { super.init(kernelFunctionName: "colorInversionKernel") }
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {}
}
