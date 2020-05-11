//
//  BBMetalDissolveBlendFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Applies a dissolve blend of two images
public class BBMetalDissolveBlendFilter: BBMetalBaseFilter {
    /// The degree with which the second image overrides the first (0.0 ~ 1.0, with 0.0 as the default)
    public var mixturePercent: Float
    
    public init(mixturePercent: Float = 0) {
        self.mixturePercent = mixturePercent
        super.init(kernelFunctionName: "dissolveBlendKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&mixturePercent, length: MemoryLayout<Float>.size, index: 0)
    }
}
