//
//  BBMetalSobelEdgeDetectionFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 7/17/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Sobel edge detection, with edges highlighted in white
public class BBMetalSobelEdgeDetectionFilter: BBMetalBaseFilter {
    /// Adjusts the dynamic range of the filter. Higher values lead to stronger edges, but can saturate the intensity colorspace. Default is 1.0
    public var edgeStrength: Float
    
    public init(edgeStrength: Float = 1) {
        self.edgeStrength = edgeStrength
        super.init(kernelFunctionName: "sobelEdgeDetectionKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&edgeStrength, length: MemoryLayout<Float>.size, index: 0)
    }
}
