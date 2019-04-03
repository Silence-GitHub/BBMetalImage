//
//  BBMetalBrightnessFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/2/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit


/// Adjusts the brightness of the image
public class BBMetalBrightnessFilter: BBMetalBaseFilter {
    /// The adjusted brightness (-1.0 ~ 1.0)
    public var brightness: Float
    
    public init(brightness: Float) {
        self.brightness = brightness
        super.init(kernelFunctionName: "brightnessKernel")
    }
    
    override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&brightness, length: MemoryLayout<Float>.size, index: 0)
    }
}
