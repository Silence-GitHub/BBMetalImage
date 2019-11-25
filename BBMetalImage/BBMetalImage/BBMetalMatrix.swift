//
//  BBMetalMatrix.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/8/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

public extension matrix_float4x4 {
    static let identity = matrix_float4x4(rows: [float4(1, 0, 0, 0),
                                                 float4(0, 1, 0, 0),
                                                 float4(0, 0, 1, 0),
                                                 float4(0, 0, 0, 1)])
}
