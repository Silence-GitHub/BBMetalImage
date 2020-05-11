//
//  BBMetalLuminanceThresholdFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/4/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Pixels with a luminance above the threshold will appear white, and those below will be black
public class BBMetalLuminanceThresholdFilter: BBMetalBaseFilter {
    /// The luminance threshold, from 0.0 to 1.0, with a default of 0.5
    public var threshold: Float
    
    public init(threshold: Float = 0.5) {
        self.threshold = threshold
        super.init(kernelFunctionName: "luminanceThresholdKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&threshold, length: MemoryLayout<Float>.size, index: 0)
    }
}
