//
//  BBMetalHighlightShadowFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/3/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Adjusts the shadows and highlights of an image
public class BBMetalHighlightShadowFilter: BBMetalBaseFilter {
    /// Increase to lighten shadows, from 0.0 to 1.0, with 0.0 as the default.
    public var shadows: Float
    
    /// Decrease to darken highlights, from 1.0 to 0.0, with 1.0 as the default.
    public var highlights: Float
    
    public init(shadows: Float = 0, highlights: Float = 1) {
        self.shadows = shadows
        self.highlights = highlights
        super.init(kernelFunctionName: "highlightShadowKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&shadows, length: MemoryLayout<Float>.size, index: 0)
        encoder.setBytes(&highlights, length: MemoryLayout<Float>.size, index: 1)
    }
}
