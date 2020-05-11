//
//  BBMetalCrosshatchFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/10/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// This converts an image into a black-and-white crosshatch pattern
public class BBMetalCrosshatchFilter: BBMetalBaseFilter {
    /// The fractional width of the image to use as the spacing for the crosshatch. The default is 0.03
    public var crosshatchSpacing: Float
    /// A relative width for the crosshatch lines. The default is 0.003
    public var lineWidth: Float
    
    public init(crosshatchSpacing: Float = 0.03, lineWidth: Float = 0.003) {
        self.crosshatchSpacing = crosshatchSpacing
        self.lineWidth = lineWidth
        super.init(kernelFunctionName: "crosshatchKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&crosshatchSpacing, length: MemoryLayout<Float>.size, index: 0)
        encoder.setBytes(&lineWidth, length: MemoryLayout<Float>.size, index: 1)
    }
}
