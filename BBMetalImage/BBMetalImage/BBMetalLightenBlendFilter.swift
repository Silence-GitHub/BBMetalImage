//
//  BBMetalLightenBlendFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Blends two images by taking the maximum value of each color component between the images
public class BBMetalLightenBlendFilter: BBMetalBaseFilter {
    public init() { super.init(kernelFunctionName: "lightenBlendKernel") }
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {}
}
