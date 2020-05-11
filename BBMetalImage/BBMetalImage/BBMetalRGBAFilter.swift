//
//  BBMetalRGBAFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/3/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Adjusts the individual RGBA channels of an image
public class BBMetalRGBAFilter: BBMetalBaseFilter {
    /// Normalized values by which each color channel is multiplied. The range is from 0.0 up, with 1.0 as the default.
    public var red: Float
    public var green: Float
    public var blue: Float
    public var alpha: Float
    
    public init(red: Float = 1, green: Float = 1, blue: Float = 1, alpha: Float = 1) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
        super.init(kernelFunctionName: "rgbaKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&red, length: MemoryLayout<Float>.size, index: 0)
        encoder.setBytes(&green, length: MemoryLayout<Float>.size, index: 1)
        encoder.setBytes(&blue, length: MemoryLayout<Float>.size, index: 2)
        encoder.setBytes(&alpha, length: MemoryLayout<Float>.size, index: 3)
    }
}
