//
//  BBMetalCropFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/11/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Crops image to the specific rect
public class BBMetalCropFilter: BBMetalBaseFilter {
    /// A rectangular area to crop out of the image, normalized to coordinates from 0.0 ~ 1.0. The (0.0, 0.0) position is in the upper left of the image
    public var rect: BBMetalRect
    
    public init(rect: BBMetalRect) {
        self.rect = rect
        super.init(kernelFunctionName: "cropKernel")
    }
    
    public override func outputTextureSize(withInputTextureSize inputSize: BBMetalIntSize) -> BBMetalIntSize {
        return BBMetalIntSize(width: Int(rect.width * Float(inputSize.width)), height: Int(rect.height * Float(inputSize.height)))
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&rect, length: MemoryLayout<BBMetalRect>.size, index: 0)
    }
}
