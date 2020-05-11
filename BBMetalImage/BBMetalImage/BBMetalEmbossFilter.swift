//
//  BBMetalEmbossFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 11/25/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import simd

private func convolutionMatrix(with intensity: Float) -> matrix_float3x3 {
    return matrix_float3x3(rows: [SIMD3<Float>(intensity * -2, -intensity, 0),
                                  SIMD3<Float>(-intensity, 1, intensity),
                                  SIMD3<Float>(0, intensity, intensity * 2)])
}

public class BBMetalEmbossFilter: BBMetalConvolution3x3Filter {
    /// The strength of the embossing (0.0 ~ 4.0, with 0.0 as the default)
    public var intensity: Float {
        didSet { convolution = convolutionMatrix(with: intensity) }
    }
    
    public init(intensity: Float = 0.0) {
        self.intensity = intensity
        super.init(convolution: convolutionMatrix(with: intensity))
    }
}
