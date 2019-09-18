//
//  BBMetalDilationFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 9/18/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void dilationKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                           texture2d<half, access::sample> inputTexture [[texture(1)]],
                           constant int *pixelRadius [[buffer(0)]],
                           uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    constexpr sampler quadSampler;
    half maxValue = 0;
    
    int radius = abs(*pixelRadius);
    for (int i = -radius; i <= radius; ++i) {
        for (int j = -radius; j <= radius; ++j) {
            const float2 coordinate = float2(float(gid.x + i) / outputTexture.get_width(), float(gid.y + j) / outputTexture.get_height());
            const half intensity = inputTexture.sample(quadSampler, coordinate).r;
            maxValue = max(maxValue, intensity);
        }
    }
    
    outputTexture.write(half4(half3(maxValue), 1), gid);
}
