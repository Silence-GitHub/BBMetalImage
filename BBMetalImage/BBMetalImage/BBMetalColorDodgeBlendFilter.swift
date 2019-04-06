//
//  BBMetalColorDodgeBlendFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

/// Applies a color dodge blend of two images
public class BBMetalColorDodgeBlendFilter: BBMetalBaseFilter {
    public init() { super.init(kernelFunctionName: "colorDodgeBlendKernel") }
    override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {}
}
