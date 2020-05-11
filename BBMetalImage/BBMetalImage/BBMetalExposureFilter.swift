//
//  BBMetalExposureFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/2/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Adjusts the exposure of the image
public class BBMetalExposureFilter: BBMetalBaseFilter {
    /// The adjusted exposure (-10.0 ~ 10.0, with 0.0 as the default)
    public var exposure: Float
    
    public init(exposure: Float = 0) {
        self.exposure = exposure
        super.init(kernelFunctionName: "exposureKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&exposure, length: MemoryLayout<Float>.size, index: 0)
    }
}
