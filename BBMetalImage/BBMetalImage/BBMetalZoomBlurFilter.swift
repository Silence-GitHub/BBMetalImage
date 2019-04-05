//
//  BBMetalZoomBlurFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

public class BBMetalZoomBlurFilter: BBMetalBaseFilter {
    public var blurSize: Float
    public var blurCenter: BBMetalPosition
    
    public init(blurSize: Float = 0, blurCenter: BBMetalPosition = .center) {
        self.blurSize = blurSize
        self.blurCenter = blurCenter
        super.init(kernelFunctionName: "zoomBlurKernel")
    }
    
    override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&blurSize, length: MemoryLayout<Float>.size, index: 0)
        encoder.setBytes(&blurCenter, length: MemoryLayout<BBMetalPosition>.size, index: 1)
    }
}
