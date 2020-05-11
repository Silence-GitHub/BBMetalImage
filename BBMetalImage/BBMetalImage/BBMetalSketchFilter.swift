//
//  BBMetalSketchFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/10/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Converts image to look like a sketch. This is just the Sobel edge detection filter with the colors inverted
public class BBMetalSketchFilter: BBMetalBaseFilter {
    /// Adjusts the dynamic range of the filter. Higher values lead to stronger edges, but can saturate the intensity colorspace. Default is 1.0
    public var edgeStrength: Float
    
    public init(edgeStrength: Float = 1) {
        self.edgeStrength = edgeStrength
        super.init(kernelFunctionName: "sketchKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&edgeStrength, length: MemoryLayout<Float>.size, index: 0)
    }
}
