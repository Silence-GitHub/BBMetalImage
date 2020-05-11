//
//  BBMetalFalseColorFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/3/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Uses the luminance of the image to mix between two user-specified colors
public class BBMetalFalseColorFilter: BBMetalBaseFilter {
    /// The first and second colors specify what colors replace the dark and light areas of the image, respectively. The defaults are red and blue.
    public var firstColor: BBMetalColor
    public var secondColor: BBMetalColor
    
    public init(firstColor: BBMetalColor = .red, secondColor: BBMetalColor = .blue) {
        self.firstColor = firstColor
        self.secondColor = secondColor
        super.init(kernelFunctionName: "falseColorKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&firstColor, length: MemoryLayout<BBMetalColor>.size, index: 0)
        encoder.setBytes(&secondColor, length: MemoryLayout<BBMetalColor>.size, index: 1)
    }
}
