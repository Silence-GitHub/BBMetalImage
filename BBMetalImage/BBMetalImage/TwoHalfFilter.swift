//
//  TwoHalfFilter.swift
//  BBMetalImageDemo
//
//  Created by Kaibo Lu on 7/25/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

public class TwoHalfFilter: BBMetalBaseFilter {
    public init() {
        super.init(kernelFunctionName: "twoHalfKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {}
}
