//
//  BBMetalZoomBlurFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Applies a zoom blur to an image
public class BBMetalZoomBlurFilter: BBMetalBaseFilter {
    /// A multiplier for the blur size, ranging from 0.0 on up, with a default of 0.0
    public var blurSize: Float
    /// The normalized center of the blur. (0.5, 0.5) by default
    public var blurCenter: BBMetalPosition
    
    public init(blurSize: Float = 0, blurCenter: BBMetalPosition = .center) {
        self.blurSize = blurSize
        self.blurCenter = blurCenter
        super.init(kernelFunctionName: "zoomBlurKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&blurSize, length: MemoryLayout<Float>.size, index: 0)
        encoder.setBytes(&blurCenter, length: MemoryLayout<BBMetalPosition>.size, index: 1)
    }
}
