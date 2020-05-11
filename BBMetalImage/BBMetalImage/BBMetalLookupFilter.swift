//
//  BBMetalLookupFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/2/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

public class BBMetalLookupFilter: BBMetalBaseFilter {
    public var lookupTable: MTLTexture
    public var intensity: Float
    
    public init(lookupTable: MTLTexture, intensity: Float = 1) {
        self.lookupTable = lookupTable
        self.intensity = intensity
        super.init(kernelFunctionName: "lookupKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setTexture(lookupTable, index: 2)
        encoder.setBytes(&intensity, length: MemoryLayout<Float>.size, index: 0)
    }
}
