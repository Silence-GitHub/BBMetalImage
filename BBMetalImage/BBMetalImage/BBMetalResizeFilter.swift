//
//  BBMetalResizeFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/12/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Resizes image to the specific size. The image will be scaled
public class BBMetalResizeFilter: BBMetalBaseFilter {
    /// Size to resize, normalized to coordinates from 0.0 ~ 1.0
    public var size: BBMetalSize
    
    public init(size: BBMetalSize) {
        self.size = size
        super.init(kernelFunctionName: "resizeKernel")
    }
    
    public override func outputTextureSize(withInputTextureSize inputSize: BBMetalIntSize) -> BBMetalIntSize {
        return BBMetalIntSize(width: Int(size.width * Float(inputSize.width)), height: Int(size.height * Float(inputSize.height)))
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&size, length: MemoryLayout<BBMetalSize>.size, index: 0)
    }
}
