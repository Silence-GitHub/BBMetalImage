//
//  BBMetalDissolveBlendFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

public class BBMetalDissolveBlendFilter: BBMetalBaseFilter {
    public var mixturePercent: Float
    
    public init(mixturePercent: Float = 0) {
        self.mixturePercent = mixturePercent
        super.init(kernelFunctionName: "dissolveBlendKernel")
    }
    
    override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&mixturePercent, length: MemoryLayout<Float>.size, index: 0)
    }
}
