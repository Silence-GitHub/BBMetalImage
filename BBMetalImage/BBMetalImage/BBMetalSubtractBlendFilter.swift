//
//  BBMetalSubtractBlendFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

public class BBMetalSubtractBlendFilter: BBMetalBaseFilter {
    public init() { super.init(kernelFunctionName: "subtractBlendKernel") }
    override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {}
}
