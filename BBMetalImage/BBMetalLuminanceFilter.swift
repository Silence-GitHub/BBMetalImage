//
//  BBMetalLuminanceFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/1/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

class BBMetalLuminanceFilter: BBMetalBaseFilter {
    convenience init() { self.init(kernelFunctionName: "luminanceKernel") }
    override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {}
}
