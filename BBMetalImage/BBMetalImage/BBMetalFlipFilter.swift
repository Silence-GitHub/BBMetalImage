//
//  BBMetalFlipFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/12/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Flips image horizontally and/or vertically
public class BBMetalFlipFilter: BBMetalBaseFilter {
    /// Whether to flip horizontally or not
    public var horizontal: Bool
    /// Whether to flip vertically or not
    public var vertical: Bool
    
    public init(horizontal: Bool, vertical: Bool) {
        self.horizontal = horizontal
        self.vertical = vertical
        super.init(kernelFunctionName: "flipKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&horizontal, length: MemoryLayout<Bool>.size, index: 0)
        encoder.setBytes(&vertical, length: MemoryLayout<Bool>.size, index: 1)
    }
}
