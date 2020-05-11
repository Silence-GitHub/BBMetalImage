//
//  BBMetalErosionFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 9/18/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Find the minimum value of the red channel in the range of radius, and set the minimum value to the current pixel.
public class BBMetalErosionFilter: BBMetalBaseFilterGroup {
    /// Radius in pixel
    public var pixelRadius: Int {
        get { return filter.pixelRadius }
        set {
            filter.pixelRadius = newValue
            filter2.pixelRadius = newValue
        }
    }
    
    private let filter: _BBMetalErosionSinglePassFilter
    private let filter2: _BBMetalErosionSinglePassFilter
    
    public init(pixelRadius: Int = 0) {
        filter = _BBMetalErosionSinglePassFilter(pixelRadius: pixelRadius, vertical: false)
        filter2 = _BBMetalErosionSinglePassFilter(pixelRadius: pixelRadius, vertical: true)
        
        filter.add(consumer: filter2)
        
        super.init(kernelFunctionName: "")
        
        initialFilters = [filter]
        terminalFilter = filter2
    }
}

fileprivate class _BBMetalErosionSinglePassFilter: BBMetalBaseFilter {
    /// Radius in pixel
    fileprivate var pixelRadius: Int
    fileprivate var vertical: Bool
    
    fileprivate init(pixelRadius: Int = 0, vertical: Bool = false) {
        self.pixelRadius = pixelRadius
        self.vertical = vertical
        super.init(kernelFunctionName: "erosionKernel")
    }
    
    fileprivate override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&pixelRadius, length: MemoryLayout<Int>.size, index: 0)
        encoder.setBytes(&vertical, length: MemoryLayout<Bool>.size, index: 1)
    }
}
