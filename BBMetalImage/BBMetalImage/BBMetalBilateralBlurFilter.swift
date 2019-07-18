//
//  BBMetalBilateralBlurFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 2019/7/17.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

public class BBMetalBilateralBlurFilter: BBMetalBaseFilterGroup {
    public var distanceNormalizationFactor: Float {
        didSet {
            filter.distanceNormalizationFactor = distanceNormalizationFactor
            filter2.distanceNormalizationFactor = distanceNormalizationFactor
        }
    }
    
    public var stepOffset: Float {
        didSet {
            filter.stepOffsetX = stepOffset
            filter2.stepOffsetY = stepOffset
        }
    }
    
    private let filter: _BBMetalBilateralBlurSinglePassFilter
    private let filter2: _BBMetalBilateralBlurSinglePassFilter
    
    public init(distanceNormalizationFactor: Float = 8, stepOffset: Float = 4) {
        self.distanceNormalizationFactor = distanceNormalizationFactor
        self.stepOffset = stepOffset
        
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
