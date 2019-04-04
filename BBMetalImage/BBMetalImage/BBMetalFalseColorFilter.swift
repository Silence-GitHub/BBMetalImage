//
//  BBMetalFalseColorFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/3/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

public class BBMetalFalseColorFilter: BBMetalBaseFilter {
    public var firstColor: BBMetalColor
    public var secondColor: BBMetalColor
    
    public init(firstColor: BBMetalColor = .red, secondColor: BBMetalColor = .blue) {
        self.firstColor = firstColor
        self.secondColor = secondColor
        super.init(kernelFunctionName: "falseColorKernel")
    }
    
    override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&firstColor, length: MemoryLayout<BBMetalColor>.size, index: 0)
        encoder.setBytes(&secondColor, length: MemoryLayout<BBMetalColor>.size, index: 1)
    }
}
