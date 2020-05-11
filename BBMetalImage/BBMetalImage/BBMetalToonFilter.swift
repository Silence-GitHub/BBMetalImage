//
//  BBMetalToonFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/11/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// This uses Sobel edge detection to place a black border around objects, and then it quantizes the colors present in the image to give a cartoon-like quality to the image
public class BBMetalToonFilter: BBMetalBaseFilter {
    /// The sensitivity of the edge detection, with lower values being more sensitive. Ranges from 0.0 to 1.0, with 0.2 as the default
    public var threshold: Float
    /// The number of color levels to represent in the final image. Default is 10.0
    public var quantizationLevels: Float
    
    public init(threshold: Float = 0.2, quantizationLevels: Float = 10) {
        self.threshold = threshold
        self.quantizationLevels = quantizationLevels
        super.init(kernelFunctionName: "toonKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&threshold, length: MemoryLayout<Float>.size, index: 0)
        encoder.setBytes(&quantizationLevels, length: MemoryLayout<Float>.size, index: 1)
    }
}
