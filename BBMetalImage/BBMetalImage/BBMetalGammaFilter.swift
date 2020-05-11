//
//  BBMetalGammaFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/3/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Adjusts the gamma of an image
public class BBMetalGammaFilter: BBMetalBaseFilter {
    /// The gamma adjustment to apply (0.0 ~ 3.0, with 1.0 as the default)
    public var gamma: Float
    
    public init(gamma: Float = 1) {
        self.gamma = gamma
        super.init(kernelFunctionName: "gammaKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&gamma, length: MemoryLayout<Float>.size, index: 0)
    }
}
