//
//  BBMetalBilateralBlurFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 2019/7/17.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// A bilateral blur, which tries to blur similar color values while preserving sharp edges
public class BBMetalBilateralBlurFilter: BBMetalBaseFilterGroup {
    /// A normalization factor for the distance between central color and sample color, with a default of 8.0
    public var distanceNormalizationFactor: Float {
        get { return filter.distanceNormalizationFactor }
        set {
            filter.distanceNormalizationFactor = newValue
            filter2.distanceNormalizationFactor = newValue
        }
    }
    
    /// A multiplier for the spacing between texel reads, ranging from 0.0 on up, with a default of 4.0
    public var stepOffset: Float {
        get { return filter.stepOffsetX }
        set {
            filter.stepOffsetX = newValue
            filter2.stepOffsetY = newValue
        }
    }
    
    private let filter: _BBMetalBilateralBlurSinglePassFilter
    private let filter2: _BBMetalBilateralBlurSinglePassFilter
    
    public init(distanceNormalizationFactor: Float = 8, stepOffset: Float = 4) {
        filter = _BBMetalBilateralBlurSinglePassFilter(distanceNormalizationFactor: distanceNormalizationFactor, stepOffsetX: stepOffset, stepOffsetY: 0)
        filter2 = _BBMetalBilateralBlurSinglePassFilter(distanceNormalizationFactor: distanceNormalizationFactor, stepOffsetX: 0, stepOffsetY: stepOffset)
        
        filter.add(consumer: filter2)
        
        super.init(kernelFunctionName: "")
        
        initialFilters = [filter]
        terminalFilter = filter2
    }
}

fileprivate class _BBMetalBilateralBlurSinglePassFilter: BBMetalBaseFilter {
    fileprivate var distanceNormalizationFactor: Float
    fileprivate var stepOffsetX: Float
    fileprivate var stepOffsetY: Float
    
    fileprivate init(distanceNormalizationFactor: Float = 8, stepOffsetX: Float = 4, stepOffsetY: Float = 4) {
        self.distanceNormalizationFactor = distanceNormalizationFactor
        self.stepOffsetX = stepOffsetX
        self.stepOffsetY = stepOffsetY
        super.init(kernelFunctionName: "bilateralBlurKernel")
    }
    
    fileprivate override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&distanceNormalizationFactor, length: MemoryLayout<Float>.size, index: 0)
        encoder.setBytes(&stepOffsetX, length: MemoryLayout<Float>.size, index: 1)
        encoder.setBytes(&stepOffsetY, length: MemoryLayout<Float>.size, index: 2)
    }
}
