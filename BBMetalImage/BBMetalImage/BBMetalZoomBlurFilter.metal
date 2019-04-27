//
//  BBMetalZoomBlurFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void zoomBlurKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                           texture2d<half, access::sample> inputTexture [[texture(1)]],
                           constant float *blurSize [[buffer(0)]],
                           constant float2 *blurCenter [[buffer(1)]],
                           uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const float2 textureCoordinate = float2(float(gid.x) / outputTexture.get_width(), float(gid.y) / outputTexture.get_height());
    const float2 samplingOffset = 1.0 / 100.0 * (float2(*blurCenter) - textureCoordinate) * float(*blurSize);
    
    constexpr sampler quadSampler;
    half4 color = inputTexture.sample(quadSampler, textureCoordinate) * 0.18;
    
    color += inputTexture.sample(quadSampler, textureCoordinate + samplingOffset) * 0.15h;
    color += inputTexture.sample(quadSampler, textureCoordinate + (2.0h * samplingOffset)) *  0.12h;
    color += inputTexture.sample(quadSampler, textureCoordinate + (3.0h * samplingOffset)) * 0.09h;
    color += inputTexture.sample(quadSampler, textureCoordinate + (4.0h * samplingOffset)) * 0.05h;
    color += inputTexture.sample(quadSampler, textureCoordinate - samplingOffset) * 0.15h;
    color += inputTexture.sample(quadSampler, textureCoordinate - (2.0h * samplingOffset)) *  0.12h;
    color += inputTexture.sample(quadSampler, textureCoordinate - (3.0h * samplingOffset)) * 0.09h;
    color += inputTexture.sample(quadSampler, textureCoordinate - (4.0h * samplingOffset)) * 0.05h;
    
    outputTexture.write(color, gid);
}
