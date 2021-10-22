//
//  DepthBlurFilter.swift
//  BBMetalImageDemo
//
//  Created by Kaibo Lu on 10/21/21.
//  Copyright © 2021 Kaibo Lu. All rights reserved.
//

import BBMetalImage

class DepthMixFilter: BBMetalBaseFilter {

    private var depthRenderParameters = DepthRenderParameters()
    
    /// Depth value to keep original image or mix with effect image.
    /// If the depth value is greater than threshold, keep original image.
    /// If the depth value is less than threshold, mix with effect image.
    /// Larger depth value means near.
    var depthThreshold: Float = 0.5
    
    init(depthThreshold: Float = 0.5) {
        self.depthThreshold = depthThreshold
        super.init(kernelFunctionName: "depthMixKernel", useMainBundleKernel: true)
    }
    
    public override func updateParameters(for encoder: MTLComputeCommandEncoder, texture: BBMetalTexture) {
        depthRenderParameters = texture.depthRenderParameters ?? .init()
        encoder.setBytes(&depthRenderParameters, length: MemoryLayout<DepthRenderParameters>.size, index: 0)
        encoder.setBytes(&depthThreshold, length: MemoryLayout<Float>.size, index: 1)
    }

}
