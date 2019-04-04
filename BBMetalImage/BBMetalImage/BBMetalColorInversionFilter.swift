//
//  BBMetalColorInversionFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/3/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

/// Inverts the colors of an image
public class BBMetalColorInversionFilter: BBMetalBaseFilter {
    public init() { super.init(kernelFunctionName: "colorInversionKernel") }
    override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {}
}
