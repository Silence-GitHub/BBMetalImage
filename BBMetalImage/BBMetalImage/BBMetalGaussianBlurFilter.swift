//
//  BBMetalGaussianBlurFilter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/4/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit
import MetalPerformanceShaders

public class BBMetalGaussianBlurFilter: BBMetalBaseFilter {
    /// The standard deviation of the gaussian blur filter
    public let sigma: Float
    
    private lazy var kernel: MPSImageGaussianBlur = { return MPSImageGaussianBlur(device: BBMetalDevice.sharedDevice, sigma: sigma) }()
    
    public init(sigma: Float) {
        self.sigma = sigma
        super.init(kernelFunctionName: "", useMPSKernel: true)
    }
    
    override func encodeMPSKernel(into commandBuffer: MTLCommandBuffer, inputTexture: MTLTexture) {
        kernel.encode(commandBuffer: commandBuffer, sourceTexture: inputTexture, destinationTexture: outputTexture!)
    }
}
