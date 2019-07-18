//
//  BBMetalBeautyFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 7/17/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

public class BBMetalBeautyFilter: BBMetalBaseFilterGroup {
    private let blurFilter: BBMetalBilateralBlurFilter
    private let edgeDetectionFilter: BBMetalSobelEdgeDetectionFilter
    private let combinationFilter: _BBMetalBeautyCombinationFilter
    
    public init() {
        blurFilter = BBMetalBilateralBlurFilter(distanceNormalizationFactor: 4)
        edgeDetectionFilter = BBMetalSobelEdgeDetectionFilter()
        combinationFilter = _BBMetalBeautyCombinationFilter()
        
        blurFilter.add(consumer: combinationFilter)
        edgeDetectionFilter.add(consumer: combinationFilter)
        
        super.init(kernelFunctionName: "")
        
        initialFilters = [blurFilter, edgeDetectionFilter, combinationFilter]
        terminalFilter = combinationFilter
    }
}

fileprivate class _BBMetalBeautyCombinationFilter: BBMetalBaseFilter {
    fileprivate var smoothDegree: Float
    
    fileprivate init(smoothDegree: Float = 0.5) {
        self.smoothDegree = smoothDegree
        super.init(kernelFunctionName: "beautyCombinationKernel")
    }
    
    override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&smoothDegree, length: MemoryLayout<Float>.size, index: 0)
    }
}
