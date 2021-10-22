//
//  BBMetalSharpenFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/4/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Sharpens the image
public class BBMetalSharpenFilter: BBMetalBaseFilter {
    /// The sharpness adjustment to apply (-4.0 ~ 4.0, with 0.0 as the default)
    public var sharpeness: Float
    
    public init(sharpeness: Float = 0) {
        self.sharpeness = sharpeness
        super.init(kernelFunctionName: "sharpenKernel")
    }
    
    public override func updateParameters(for encoder: MTLComputeCommandEncoder, texture: BBMetalTexture) {
        encoder.setBytes(&sharpeness, length: MemoryLayout<Float>.size, index: 0)
    }
}
