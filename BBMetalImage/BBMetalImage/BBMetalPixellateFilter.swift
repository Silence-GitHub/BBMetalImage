//
//  BBMetalPixellateFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/10/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Applies a pixellation effect on an image
public class BBMetalPixellateFilter: BBMetalBaseFilter {
    /// How large the pixels are, as a fraction of the width of the image (0.0 ~ 1.0, default 0.05)
    public var fractionalWidth: Float
    
    public init(fractionalWidth: Float = 0.05) {
        self.fractionalWidth = fractionalWidth
        super.init(kernelFunctionName: "pixellateKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&fractionalWidth, length: MemoryLayout<Float>.size, index: 0)
    }
}
