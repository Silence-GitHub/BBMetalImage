//
//  BBMetalLuminosityBlendFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/6/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

/// Applies a luminosity blend of two images
public class BBMetalLuminosityBlendFilter: BBMetalBaseFilter {
    public init() { super.init(kernelFunctionName: "luminosityBlendKernel") }
    override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {}
}
