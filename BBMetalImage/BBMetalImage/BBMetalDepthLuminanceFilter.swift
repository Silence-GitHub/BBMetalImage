//
//  BBMetalDepthLuminanceFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 10/21/21.
//  Copyright © 2021 Kaibo Lu. All rights reserved.
//

import Metal

/// Converts depth data to grayscale
public class BBMetalDepthLuminanceFilter: BBMetalBaseFilter {
    
    private var depthRenderParameters = DepthRenderParameters()
    
    public init() { super.init(kernelFunctionName: "depthLuminanceKernel") }
    
    public override func updateParameters(for encoder: MTLComputeCommandEncoder, texture: BBMetalTexture) {
        depthRenderParameters = texture.depthRenderParameters ?? .init()
        encoder.setBytes(&depthRenderParameters, length: MemoryLayout<DepthRenderParameters>.size, index: 0)
    }
}
