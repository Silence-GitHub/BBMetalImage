//
//  BBMetalWhiteBalanceFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/3/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

private func convertTemperature(_ temperature: Float) -> Float {
    return temperature < 5000 ? 0.0004 * (temperature - 5000) : 0.00006 * (temperature - 5000)
}

private func convertTint(_ tint: Float) -> Float {
    return tint / 100
}

public class BBMetalWhiteBalanceFilter: BBMetalBaseFilter {
    public var temperature: Float { didSet { _temperature = convertTemperature(temperature) } }
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
    
    override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&_temperature, length: MemoryLayout<Float>.size, index: 0)
        encoder.setBytes(&_tint, length: MemoryLayout<Float>.size, index: 1)
    }
}
