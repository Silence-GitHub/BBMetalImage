//
//  BBMetalSobelEdgeDetectionFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 7/17/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

public class BBMetalSobelEdgeDetectionFilter: BBMetalBaseFilter {
    public var edgeStrength: Float
    
    public init(edgeStrength: Float = 1) {
        self.edgeStrength = edgeStrength
        super.init(kernelFunctionName: "sobelEdgeDetectionKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&edgeStrength, length: MemoryLayout<Float>.size, index: 0)
    }
}
