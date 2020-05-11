//
//  BBMetalHalftoneFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/10/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Applies a halftone effect to an image, like news print
public class BBMetalHalftoneFilter: BBMetalBaseFilter {
    /// How large the halftone dots are, as a fraction of the width of the image (0.0 ~ 1.0, default 0.01)
    public var fractionalWidth: Float
    
    public init(fractionalWidth: Float = 0.01) {
        self.fractionalWidth = fractionalWidth
        super.init(kernelFunctionName: "halftoneKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&fractionalWidth, length: MemoryLayout<Float>.size, index: 0)
    }
}
