//
//  BBMetalPolarPixellateFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/10/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Applies a pixellation effect on an image based on polar coordinates
public class BBMetalPolarPixellateFilter: BBMetalBaseFilter {
    /// The fractional pixel size, split into width and height components. The default is (0.05, 0.05)
    public var pixelSize: BBMetalSize
    /// The center about which to apply the pixellation, defaulting to (0.5, 0.5)
    public var center: BBMetalPosition
    
    public init(pixelSize: BBMetalSize = BBMetalSize(width: 0.05, height: 0.05), center: BBMetalPosition = .center) {
        self.pixelSize = pixelSize
        self.center = center
        super.init(kernelFunctionName: "polarPixellateKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&pixelSize, length: MemoryLayout<BBMetalSize>.size, index: 0)
        encoder.setBytes(&center, length: MemoryLayout<BBMetalPosition>.size, index: 1)
    }
}
