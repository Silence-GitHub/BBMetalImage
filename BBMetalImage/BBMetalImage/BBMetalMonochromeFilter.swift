//
//  BBMetalMonochromeFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/3/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Converts the image to a single-color version, based on the luminance of each pixel
public class BBMetalMonochromeFilter: BBMetalBaseFilter {
    /// The color to use as the basis for the effect, with red as the default
    public var color: BBMetalColor
    /// The degree to which the specific color replaces the normal image color (0.0 ~ 1.0, with 1.0 as the default)
    public var intensity: Float
    
    public init(color: BBMetalColor = .red, intensity: Float = 0) {
        self.color = color
        self.intensity = intensity
        super.init(kernelFunctionName: "monochromeKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&color, length: MemoryLayout<BBMetalColor>.size, index: 0)
        encoder.setBytes(&intensity, length: MemoryLayout<Float>.size, index: 1)
    }
}
