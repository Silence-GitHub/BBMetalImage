//
//  BBMetalHighlightShadowTintFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/3/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Allows you to tint the shadows and highlights of an image independently using a color and intensity
public class BBMetalHighlightShadowTintFilter: BBMetalBaseFilter {
    /// Shadow tint RGB color, with red as the default
    public var shadowTintColor: BBMetalColor
    /// Shadow tint intensity, from 0.0 to 1.0, with 0.0 as the default
    public var shadowTintIntensity: Float
    
    /// Highlight tint RGB color, with blue as the default
    public var highlightTintColor: BBMetalColor
    /// Highlight tint intensity, from 0.0 to 1.0, with 0.0 as the default
    public var highlightTintIntensity: Float
    
    public init(shadowTintColor: BBMetalColor = .red,
                shadowTintIntensity: Float = 0,
                highlightTintColor: BBMetalColor = .blue,
                highlightTintIntensity: Float = 0) {
        
        self.shadowTintColor = shadowTintColor
        self.shadowTintIntensity = shadowTintIntensity
        self.highlightTintColor = highlightTintColor
        self.highlightTintIntensity = highlightTintIntensity
        super.init(kernelFunctionName: "highlightShadowTintKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&shadowTintColor, length: MemoryLayout<BBMetalColor>.size, index: 0)
        encoder.setBytes(&shadowTintIntensity, length: MemoryLayout<Float>.size, index: 1)
        encoder.setBytes(&highlightTintColor, length: MemoryLayout<BBMetalColor>.size, index: 2)
        encoder.setBytes(&highlightTintIntensity, length: MemoryLayout<Float>.size, index: 3)
    }
}
