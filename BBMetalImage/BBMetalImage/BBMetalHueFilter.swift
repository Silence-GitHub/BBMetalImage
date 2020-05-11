//
//  BBMetalHueFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/3/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

private func convertHue(_ hue: Float) -> Float {
    return fmodf(hue, 360) * Float.pi / 180
}

/// Adjusts the hue of an image
public class BBMetalHueFilter: BBMetalBaseFilter {
    /// The hue angle, in degrees. 0 degrees by default
    public var hue: Float { didSet { _hue = convertHue(hue) } }
    
    private var _hue: Float
    
    public init(hue: Float = 0) {
        self.hue = hue
        self._hue = convertHue(hue)
        super.init(kernelFunctionName: "hueKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&_hue, length: MemoryLayout<Float>.size, index: 0)
    }
}
