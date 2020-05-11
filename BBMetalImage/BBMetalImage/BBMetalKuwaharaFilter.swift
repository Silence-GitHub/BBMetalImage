//
//  BBMetalKuwaharaFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 11/22/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Kuwahara image abstraction, drawn from the work of Kyprianidis, et. al. in their publication "Anisotropic Kuwahara Filtering on the GPU" within the GPU Pro collection. This produces an oil-painting-like image, but it is extremely computationally expensive. This might be best used for still images.
public class BBMetalKuwaharaFilter: BBMetalBaseFilter {
    /// The radius to sample from when creating the brush-stroke effect, with a default of 3. The larger the radius, the slower the filter.
    public var radius: Int
    
    public init(radius: Int = 3) {
        self.radius = radius
        super.init(kernelFunctionName: "kuwaharaKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&radius, length: MemoryLayout<Int>.size, index: 0)
    }
}
