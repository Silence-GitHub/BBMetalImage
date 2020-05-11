//
//  BBMetalChromaKeyFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/4/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// For a given color in the image, sets the alpha channel to 0
public class BBMetalChromaKeyFilter: BBMetalBaseFilter {
    /// How close a color match needs to exist to the target color to be replaced (default of 0.4)
    public var thresholdSensitivity: Float
    /// How smoothly to blend for the color match (default of 0.1)
    public var smoothing: Float
    public var colorToReplace: BBMetalColor
    
    public init(thresholdSensitivity: Float = 0.4, smoothing: Float = 0.1, colorToReplace: BBMetalColor = .green) {
        self.thresholdSensitivity = thresholdSensitivity
        self.smoothing = smoothing
        self.colorToReplace = colorToReplace
        super.init(kernelFunctionName: "chromaKeyKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&thresholdSensitivity, length: MemoryLayout<Float>.size, index: 0)
        encoder.setBytes(&smoothing, length: MemoryLayout<Float>.size, index: 1)
        encoder.setBytes(&colorToReplace, length: MemoryLayout<BBMetalColor>.size, index: 2)
    }
}
