//
//  BBMetalErosionFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 9/18/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

/// Find the min color intensity in the range of radius, and set the min value to the current pixel.
public class BBMetalErosionFilter: BBMetalBaseFilter {
    /// Radius in pixel
    var pixelRadius: Int
    
    public init(pixelRadius: Int = 0) {
        self.pixelRadius = pixelRadius
        super.init(kernelFunctionName: "erosionKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&pixelRadius, length: MemoryLayout<Int>.size, index: 0)
    }
}
