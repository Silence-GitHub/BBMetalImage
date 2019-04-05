//
//  BBMetalSharpenFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/4/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

public class BBMetalSharpenFilter: BBMetalBaseFilter {
    public var sharpeness: Float
    
    public init(sharpeness: Float = 0) {
        self.sharpeness = sharpeness
        super.init(kernelFunctionName: "sharpenKernel")
    }
    
    override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&sharpeness, length: MemoryLayout<Float>.size, index: 0)
    }
}
