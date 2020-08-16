//
//  BBMetalVignetteFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 8/16/20.
//  Copyright © 2020 Kaibo Lu. All rights reserved.
//

import UIKit

/// Performs a vignetting effect, fading out the image at the edges
public class BBMetalVignetteFilter: BBMetalBaseFilter {
    /// The center for the vignette, with a default of (0.5, 0.5)
    public var center: BBMetalPosition
    
    /// The color to use for the vignette, with a default of black
    public var color: BBMetalOpaqueColor
    
    /// The normalized distance from the center where the vignette effect starts, with a default of 0.3
    public var start: Float
    
    /// The normalized distance from the center where the vignette effect ends, with a default of 0.75
    public var end: Float
    
    public init(center: BBMetalPosition = .center, color: BBMetalOpaqueColor = .black, start: Float = 0.3, end: Float = 0.75) {
        self.center = center
        self.color = color
        self.start = start
        self.end = end
        super.init(kernelFunctionName: "vignetteKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&center, length: MemoryLayout<BBMetalPosition>.size, index: 0)
        encoder.setBytes(&color, length: MemoryLayout<BBMetalOpaqueColor>.stride, index: 1)
        encoder.setBytes(&start, length: MemoryLayout<Float>.size, index: 2)
        encoder.setBytes(&end, length: MemoryLayout<Float>.size, index: 3)
    }
}
