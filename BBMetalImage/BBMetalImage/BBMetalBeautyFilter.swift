//
//  BBMetalBeautyFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 7/17/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

public class BBMetalBeautyFilter: BBMetalBaseFilterGroup {
    public var distanceNormalizationFactor: Float {
        get { return blurFilter.distanceNormalizationFactor }
        set { blurFilter.distanceNormalizationFactor = newValue }
    }
    
    public var stepOffset: Float {
        get { return blurFilter.stepOffset }
        set { blurFilter.stepOffset = newValue }
    }
    
    public var edgeStrength: Float {
        get { return edgeDetectionFilter.edgeStrength }
        set { edgeDetectionFilter.edgeStrength = newValue }
    }
    
    public var smoothDegree: Float {
        get { return combinationFilter.smoothDegree }
        set { combinationFilter.smoothDegree = newValue }
    }
    
    private let blurFilter: BBMetalBilateralBlurFilter
    private let edgeDetectionFilter: BBMetalSobelEdgeDetectionFilter
    private let combinationFilter: _BBMetalBeautyCombinationFilter
    
    public init(distanceNormalizationFactor: Float = 4, stepOffset: Float = 4, edgeStrength: Float = 1, smoothDegree: Float = 0.5) {
        blurFilter = BBMetalBilateralBlurFilter(distanceNormalizationFactor: distanceNormalizationFactor, stepOffset: stepOffset)
        edgeDetectionFilter = BBMetalSobelEdgeDetectionFilter(edgeStrength: edgeStrength)
        combinationFilter = _BBMetalBeautyCombinationFilter(smoothDegree: smoothDegree)
        
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
