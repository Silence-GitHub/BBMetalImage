//
//  BBMetalHueFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/3/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

/// Adjusts the hue of an image
public class BBMetalHueFilter: BBMetalBaseFilter {
    /// The hue angle, in degrees. 0 degrees by default
    public var hue: Float
    
    public init(hue: Float = 0) {
        self.hue = hue
        super.init(kernelFunctionName: "hueKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&hue, length: MemoryLayout<Float>.size, index: 0)
    }
}
