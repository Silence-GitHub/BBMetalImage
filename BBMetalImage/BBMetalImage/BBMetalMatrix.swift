//
//  BBMetalMatrix.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/8/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import simd

public extension matrix_float4x4 {
    static let identity = matrix_float4x4(rows: [SIMD4<Float>(1, 0, 0, 0),
                                                 SIMD4<Float>(0, 1, 0, 0),
                                                 SIMD4<Float>(0, 0, 1, 0),
                                                 SIMD4<Float>(0, 0, 0, 1)])
}
