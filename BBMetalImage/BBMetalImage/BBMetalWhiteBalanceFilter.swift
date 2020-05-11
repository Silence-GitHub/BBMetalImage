//
//  BBMetalWhiteBalanceFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/3/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

private func convertTemperature(_ temperature: Float) -> Float {
    return temperature < 5000 ? 0.0004 * (temperature - 5000) : 0.00006 * (temperature - 5000)
}

private func convertTint(_ tint: Float) -> Float {
    return tint / 100
}

/// Adjusts the white balance of an image
public class BBMetalWhiteBalanceFilter: BBMetalBaseFilter {
    /// The temperature to adjust the image by, in ºK. A value of 4000 is very cool and 7000 very warm. The default value is 5000. Note that the scale between 4000 and 5000 is nearly as visually significant as that between 5000 and 7000.
    public var temperature: Float { didSet { _temperature = convertTemperature(temperature) } }
    
    /// The tint to adjust the image by. A value of -200 is very green and 200 is very pink. The default value is 0.
    public var tint: Float { didSet { _tint = convertTint(tint) } }
    
    private var _temperature: Float
    private var _tint: Float
    
    public init(temperature: Float = 5000, tint: Float = 0) {
        self.temperature = temperature
        _temperature = convertTemperature(temperature)
        self.tint = tint
        _tint = convertTint(tint)
        super.init(kernelFunctionName: "whiteBalanceKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&_temperature, length: MemoryLayout<Float>.size, index: 0)
        encoder.setBytes(&_tint, length: MemoryLayout<Float>.size, index: 1)
    }
}
