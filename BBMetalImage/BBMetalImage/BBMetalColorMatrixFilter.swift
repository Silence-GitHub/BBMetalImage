//
//  BBMetalColorMatrixFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/8/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal
import simd

/// Transforms the colors of an image by applying a matrix to them
public class BBMetalColorMatrixFilter: BBMetalBaseFilter {
    /// A 4x4 matrix used to transform each color in an image
    public var colorMatrix: matrix_float4x4
    /// The degree to which the new transformed color replaces the original color for each pixel
    public var intensity: Float
    
    public init(colorMatrix: matrix_float4x4 = .identity, intensity: Float = 1) {
        self.intensity = intensity
        self.colorMatrix = colorMatrix
        super.init(kernelFunctionName: "colorMatrixKernel")
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&intensity, length: MemoryLayout<Float>.size, index: 0)
        encoder.setBytes(&colorMatrix, length: MemoryLayout<matrix_float4x4>.size, index: 1)
    }
}
