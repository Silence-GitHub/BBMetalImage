//
//  BBMetalHazeFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/4/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Used to add or remove haze (similar to a UV filter)
public class BBMetalHazeFilter: BBMetalBaseFilter {
    /// Strength of the color applied. Default 0. Values between -0.3 and 0.3 are best
    public var distance: Float
    /// Amount of color change. Default 0. Values between -0.3 and 0.3 are best
    public var slope: Float
    
    public init(distance: Float = 0, slope: Float = 0) {
        self.distance = distance
        self.slope = slope
        super.init(kernelFunctionName: "hazeKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&distance, length: MemoryLayout<Float>.size, index: 0)
        encoder.setBytes(&slope, length: MemoryLayout<Float>.size, index: 1)
    }
}
