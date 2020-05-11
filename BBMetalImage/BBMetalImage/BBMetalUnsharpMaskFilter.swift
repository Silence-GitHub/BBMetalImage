//
//  BBMetalUnsharpMaskFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/11/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// Applies an unsharp mask
public class BBMetalUnsharpMaskFilter: BBMetalBaseFilterGroup {
    /// The standard deviation of the underlying gaussian blur filter. The default is 4.0
    public var sigma: Float { return blurFilter.sigma }
    
    /// The strength of the sharpening, from 0.0 on up, with a default of 1.0
    public var intensity: Float {
        get { return maskFilter.intensity }
        set { maskFilter.intensity = newValue }
    }
    
    private let blurFilter: BBMetalGaussianBlurFilter
    private let maskFilter: _BBMetalUnsharpMaskFilter
    
    public init(sigma: Float = 4, intensity: Float = 1) {
        blurFilter = BBMetalGaussianBlurFilter(sigma: sigma)
        maskFilter = _BBMetalUnsharpMaskFilter(intensity: intensity)
        
        blurFilter.add(consumer: maskFilter)
        
        super.init(kernelFunctionName: "")
        
        initialFilters = [blurFilter, maskFilter]
        terminalFilter = maskFilter
    }
}

fileprivate class _BBMetalUnsharpMaskFilter: BBMetalBaseFilter {
    fileprivate var intensity: Float
    
    fileprivate init(intensity: Float = 1) {
        self.intensity = intensity
        super.init(kernelFunctionName: "unsharpMaskKernel")
    }
    
    override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&intensity, length: MemoryLayout<Float>.size, index: 0)
    }
}
