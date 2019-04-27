//
//  BBMetalSharpenFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/4/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void sharpenKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                          texture2d<half, access::sample> inputTexture [[texture(1)]],
                          constant float *sharpeness [[buffer(0)]],
                          uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const float x = float(gid.x);
    const float y = float(gid.y);
    const float width = float(inputTexture.get_width());
    const float height = float(inputTexture.get_height());
    
    const float2 leftCoordinate = float2((x - 1) / width, y / height);
    const float2 rightCoordinate = float2((x + 1) / width, y / height);
    const float2 topCoordinate = float2(x / width, (y - 1) / height);
    const float2 bottomCoordinate = float2(x / width, (y + 1) / height);
    
    const half4 inColor = inputTexture.read(gid);
    
    constexpr sampler quadSampler;
    const half4 leftColor = inputTexture.sample(quadSampler, leftCoordinate);
    const half4 rightColor = inputTexture.sample(quadSampler, rightCoordinate);
    const half4 topColor = inputTexture.sample(quadSampler, topCoordinate);
    const half4 bottomColor = inputTexture.sample(quadSampler, bottomCoordinate);
    
    const half centerMultiplier = 1.0 + 4.0 * half(*sharpeness);
    const half edgeMultiplier = half(*sharpeness);
    const half4 outColor((inColor.rgb * centerMultiplier - (leftColor.rgb + rightColor.rgb + topColor.rgb + bottomColor.rgb) * edgeMultiplier), bottomColor.a);
    outputTexture.write(outColor, gid);
}
