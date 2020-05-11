//
//  BBMetalTiltShiftFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/11/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// A simulated tilt shift lens effect
public class BBMetalTiltShiftFilter: BBMetalBaseFilterGroup {
    /// The standard deviation of the underlying gaussian blur filter. The default is 7.0
    public var sigma: Float { return blurFilter.sigma }
    
    /// The normalized location of the top of the in-focus area in the image, this value should be lower than bottomFocusLevel, default 0.4
    public var topFocusLevel: Float {
        get { return tiltShiftFilter.topFocusLevel }
        set { tiltShiftFilter.topFocusLevel = newValue }
    }
    
    /// The normalized location of the bottom of the in-focus area in the image, this value should be higher than topFocusLevel, default 0.6
    public var bottomFocusLevel: Float {
        get { return tiltShiftFilter.bottomFocusLevel }
        set { tiltShiftFilter.bottomFocusLevel = newValue }
    }
    
    /// The rate at which the image gets blurry away from the in-focus region, default 0.2
    public var focusFallOffRate: Float {
        get { return tiltShiftFilter.focusFallOffRate }
        set { tiltShiftFilter.focusFallOffRate = newValue }
    }
    
    private let blurFilter: BBMetalGaussianBlurFilter
    private let tiltShiftFilter: _BBMetalTiltShiftFilter
    
    public init(sigma: Float = 7,
                topFocusLevel: Float = 0.4,
                bottomFocusLevel: Float = 0.6,
                focusFallOffRate: Float = 0.2) {
        
        blurFilter = BBMetalGaussianBlurFilter(sigma: sigma)
        tiltShiftFilter = _BBMetalTiltShiftFilter()
        
        blurFilter.add(consumer: tiltShiftFilter)
        
        super.init(kernelFunctionName: "")
        
        initialFilters = [blurFilter, tiltShiftFilter]
        terminalFilter = tiltShiftFilter
    }
}

fileprivate class _BBMetalTiltShiftFilter: BBMetalBaseFilter {
    fileprivate var topFocusLevel: Float
    fileprivate var bottomFocusLevel: Float
    fileprivate var focusFallOffRate: Float
    
    fileprivate init(topFocusLevel: Float = 0.4, bottomFocusLevel: Float = 0.6, focusFallOffRate: Float = 0.2) {
        self.topFocusLevel = topFocusLevel
        self.bottomFocusLevel = bottomFocusLevel
        self.focusFallOffRate = focusFallOffRate
        super.init(kernelFunctionName: "tiltShiftKernel")
    }
    
    override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&topFocusLevel, length: MemoryLayout<Float>.size, index: 0)
        encoder.setBytes(&bottomFocusLevel, length: MemoryLayout<Float>.size, index: 1)
        encoder.setBytes(&focusFallOffRate, length: MemoryLayout<Float>.size, index: 2)
    }
}
