//
//  BBMetalChromaKeyBlendFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Selectively replaces a color in the first image with the second image
public class BBMetalChromaKeyBlendFilter: BBMetalBaseFilter {
    /// How close a color match needs to exist to the target color to be replaced (default of 0.4)
    public var thresholdSensitivity: Float
    /// How smoothly to blend for the color match (default of 0.1)
    public var smoothing: Float
    public var colorToReplace: BBMetalColor
    
    public init(thresholdSensitivity: Float = 0.4, smoothing: Float = 0.1, colorToReplace: BBMetalColor = .green) {
        self.thresholdSensitivity = thresholdSensitivity
        self.smoothing = smoothing
        self.colorToReplace = colorToReplace
        super.init(kernelFunctionName: "chromaKeyBlendKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&thresholdSensitivity, length: MemoryLayout<Float>.size, index: 0)
        encoder.setBytes(&smoothing, length: MemoryLayout<Float>.size, index: 1)
        encoder.setBytes(&colorToReplace, length: MemoryLayout<BBMetalColor>.size, index: 2)
    }
}
