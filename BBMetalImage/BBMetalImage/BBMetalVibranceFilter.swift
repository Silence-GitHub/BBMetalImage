//
//  BBMetalVibranceFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/3/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Adjusts the vibrance of an image
public class BBMetalVibranceFilter: BBMetalBaseFilter {
    /// The vibrance adjustment to apply, using 0.0 as the default, and a suggested min/max of around -1.2 and 1.2, respectively.
    public var vibrance: Float
    
    public init(vibrance: Float = 0) {
        self.vibrance = vibrance
        super.init(kernelFunctionName: "vibranceKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&vibrance, length: MemoryLayout<Float>.size, index: 0)
    }
}
