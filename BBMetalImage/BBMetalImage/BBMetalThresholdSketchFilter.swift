//
//  BBMetalThresholdSketchFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/10/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Same as the sketch filter, only the edges are thresholded instead of being grayscale
public class BBMetalThresholdSketchFilter: BBMetalBaseFilter {
    /// Adjusts the dynamic range of the filter. Higher values lead to stronger edges, but can saturate the intensity colorspace. Default is 1.0
    public var edgeStrength: Float
    /// Any edge above this threshold will be black, and anything below white. Ranges from 0.0 to 1.0, with 0.25 as the default
    public var threshold: Float
    
    public init(edgeStrength: Float = 1, threshold: Float = 0.25) {
        self.edgeStrength = edgeStrength
        self.threshold = threshold
        super.init(kernelFunctionName: "thresholdSketchKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&edgeStrength, length: MemoryLayout<Float>.size, index: 0)
        encoder.setBytes(&threshold, length: MemoryLayout<Float>.size, index: 1)
    }
}
