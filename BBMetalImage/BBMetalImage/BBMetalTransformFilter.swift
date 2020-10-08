//
//  BBMetalTransformFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 10/6/20.
//  Copyright © 2020 Kaibo Lu. All rights reserved.
//

import Metal

/// Applies affine transform to an image
public class BBMetalTransformFilter: BBMetalBaseFilter {
    
    private static func matrix(from: CGAffineTransform) -> matrix_float3x2 {
        return matrix_float3x2(columns: (simd_float2(x: Float(from.a ), y: Float(from.b )),
                                         simd_float2(x: Float(from.c ), y: Float(from.d )),
                                         simd_float2(x: Float(from.tx), y: Float(from.ty))))
    }
    
    /// Affine transform to apply
    public var transform: CGAffineTransform {
        get {
            return CGAffineTransform(a:  CGFloat(_matrix[0][0]), b:  CGFloat(_matrix[0][1]),
                                     c:  CGFloat(_matrix[1][0]), d:  CGFloat(_matrix[1][1]),
                                     tx: CGFloat(_matrix[2][0]), ty: CGFloat(_matrix[2][1]))
        }
        set {
            _matrix = BBMetalTransformFilter.matrix(from: newValue)
        }
    }
    private var _matrix: matrix_float3x2
    
    /// True to change image size to fit transformed image, false to keep image size
    public var fitSize: Bool
    
    public init(transform: CGAffineTransform = .identity, fitSize: Bool = true) {
        self._matrix = BBMetalTransformFilter.matrix(from: transform)
        self.fitSize = fitSize
        super.init(kernelFunctionName: "transformKernel")
    }
    
    public override func newTextureAvailable(_ texture: BBMetalTexture, from source: BBMetalImageSource) {
        if transform != .identity {
            super.newTextureAvailable(texture, from: source)
        } else {
            // Transmit output texture to image consumers
            for consumer in consumers { consumer.newTextureAvailable(texture, from: self) }
        }
    }
    
    public override func outputTextureSize(withInputTextureSize inputSize: BBMetalIntSize) -> BBMetalIntSize {
        if fitSize {
            let newSize = CGRect(x: 0, y: 0, width: inputSize.width, height: inputSize.height).applying(transform)
            return BBMetalIntSize(width: Int(newSize.width), height: Int(newSize.height))
        }
        return inputSize
    }
    
    public override func updateParameters(forComputeCommandEncoder encoder: MTLComputeCommandEncoder) {
        encoder.setBytes(&_matrix, length: MemoryLayout<matrix_float3x2>.size, index: 0)
    }
}
