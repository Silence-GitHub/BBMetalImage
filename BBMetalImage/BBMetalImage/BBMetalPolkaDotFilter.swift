//
//  BBMetalPolkaDotFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/10/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

public class BBMetalPolkaDotFilter: BBMetalBaseFilter {
    public var fractionalWidth: Float
    public var dotScaling: Float
    
    public init(fractionalWidth: Float = 0.05, dotScaling: Float = 0.9) {
        self.fractionalWidth = fractionalWidth
        self.dotScaling = dotScaling
        super.init(kernelFunctionName: "polkaDotKernel")
    }
    
    override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&fractionalWidth, length: MemoryLayout<Float>.size, index: 0)
        encoder.setBytes(&dotScaling, length: MemoryLayout<Float>.size, index: 1)
    }
}
