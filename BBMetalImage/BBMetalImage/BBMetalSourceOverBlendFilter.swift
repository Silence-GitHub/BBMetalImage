//
//  BBMetalSourceOverBlendFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

/// Applies a source over blend of two images
public class BBMetalSourceOverBlendFilter: BBMetalBaseFilter {
    public init() { super.init(kernelFunctionName: "sourceOverBlendKernel") }
    override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {}
}
