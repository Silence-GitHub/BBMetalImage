//
//  BBMetalBilateralBlurFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 2019/7/17.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

public class BBMetalBilateralBlurFilter: BBMetalBaseFilter {
    public var distanceNormalizationFactor: Float
    
    public init(distanceNormalizationFactor: Float = 8) {
        self.distanceNormalizationFactor = distanceNormalizationFactor
        super.init(kernelFunctionName: "bilateralBlurKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&distanceNormalizationFactor, length: MemoryLayout<Float>.size, index: 0)
    }
}
