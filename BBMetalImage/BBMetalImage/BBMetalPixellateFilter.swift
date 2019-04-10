//
//  BBMetalPixellateFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/10/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

/// Applies a pixellation effect on an image
public class BBMetalPixellateFilter: BBMetalBaseFilter {
    /// How large the pixels are, as a fraction of the width and height of the image (0.0 ~ 1.0, default 0.05)
    public var pixelSize: BBMetalSize
    
    public init(pixelSize: BBMetalSize = BBMetalSize(width: 0.05, height: 0.05)) {
        self.pixelSize = pixelSize
        super.init(kernelFunctionName: "pixellateKernel")
    }
    
    override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&pixelSize, length: MemoryLayout<BBMetalSize>.size, index: 0)
    }
}
