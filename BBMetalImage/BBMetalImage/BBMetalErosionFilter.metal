//
//  BBMetalErosionFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 9/18/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void erosionKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                          texture2d<half, access::sample> inputTexture [[texture(1)]],
                          constant int *pixelRadius [[buffer(0)]],
                          constant bool *vertical [[buffer(1)]],
                          uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    constexpr sampler quadSampler;
    half minValue = 1;
    
    int radius = abs(*pixelRadius);
    if (*vertical) {
        for (int i = -radius; i <= radius; ++i) {
            const float2 coordinate = float2(float(gid.x) / outputTexture.get_width(), float(gid.y + i) / outputTexture.get_height());
            const half intensity = inputTexture.sample(quadSampler, coordinate).r;
            minValue = min(minValue, intensity);
        }
    } else {
        for (int i = -radius; i <= radius; ++i) {
            const float2 coordinate = float2(float(gid.x + i) / outputTexture.get_width(), float(gid.y) / outputTexture.get_height());
            const half intensity = inputTexture.sample(quadSampler, coordinate).r;
            minValue = min(minValue, intensity);
        }
    }
    
    outputTexture.write(half4(half3(minValue), 1), gid);
}
