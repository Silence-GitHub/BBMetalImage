//
//  BBMetalLevelsFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/8/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/**
 Photoshop-like levels adjustment. The min, max, minOut and maxOut parameters are floats in the range [0, 1]. If you have parameters from Photoshop in the range [0, 255] you must first convert them to be [0, 1]. The gamma/mid parameter is a float >= 0. This matches the value from Photoshop. If you want to apply levels to RGB as well as individual channels you need to use this filter twice - first for the individual channels and then for all channels.
 */
public class BBMetalLevelsFilter: BBMetalBaseFilter {
    public var minimum: BBMetalColor
    public var middle: BBMetalColor
    public var maximum: BBMetalColor
    public var minOutput: BBMetalColor
    public var maxOutput: BBMetalColor
    
    public init(minimum: BBMetalColor = .black,
                middle: BBMetalColor = .white,
                maximum: BBMetalColor = .white,
                minOutput: BBMetalColor = .black,
                maxOutput: BBMetalColor = .white) {
        self.minimum = minimum
        self.middle = middle
        self.maximum = maximum
        self.minOutput = minOutput
        self.maxOutput = maxOutput
        super.init(kernelFunctionName: "levelsKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&minimum, length: MemoryLayout<BBMetalColor>.size, index: 0)
        encoder.setBytes(&middle, length: MemoryLayout<BBMetalColor>.size, index: 1)
        encoder.setBytes(&maximum, length: MemoryLayout<BBMetalColor>.size, index: 2)
        encoder.setBytes(&minOutput, length: MemoryLayout<BBMetalColor>.size, index: 3)
        encoder.setBytes(&maxOutput, length: MemoryLayout<BBMetalColor>.size, index: 4)
    }
}
