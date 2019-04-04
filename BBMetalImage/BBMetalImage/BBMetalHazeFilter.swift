//
//  BBMetalHazeFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/4/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

public class BBMetalHazeFilter: BBMetalBaseFilter {
    public var distance: Float
    public var slope: Float
    
    public init(distance: Float = 0, slope: Float = 0) {
        self.distance = distance
        self.slope = slope
        super.init(kernelFunctionName: "hazeKernel")
    }
    
    override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&distance, length: MemoryLayout<Float>.size, index: 0)
        encoder.setBytes(&slope, length: MemoryLayout<Float>.size, index: 1)
    }
}
