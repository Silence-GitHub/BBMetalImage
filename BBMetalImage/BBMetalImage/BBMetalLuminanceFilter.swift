//
//  BBMetalLuminanceFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/1/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Converts an image to grayscale
public class BBMetalLuminanceFilter: BBMetalBaseFilter {
    public init() { super.init(kernelFunctionName: "luminanceKernel") }
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {}
}
