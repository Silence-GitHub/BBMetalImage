//
//  BBMetalPolkaDotFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/10/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Breaks an image up into colored dots within a regular grid
public class BBMetalPolkaDotFilter: BBMetalBaseFilter {
    /// How large the dots are, as a fraction of the width and height of the image (0.0 ~ 1.0, default 0.05)
    public var fractionalWidth: Float
    /// What fraction of each grid space is taken up by a dot, from 0.0 to 1.0 with a default of 0.9
    public var dotScaling: Float
    
    public init(fractionalWidth: Float = 0.05, dotScaling: Float = 0.9) {
        self.fractionalWidth = fractionalWidth
        self.dotScaling = dotScaling
        super.init(kernelFunctionName: "polkaDotKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&fractionalWidth, length: MemoryLayout<Float>.size, index: 0)
        encoder.setBytes(&dotScaling, length: MemoryLayout<Float>.size, index: 1)
    }
}
