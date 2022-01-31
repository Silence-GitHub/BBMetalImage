//
//  BBMetalCropFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/11/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void cropKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                       texture2d<half, access::sample> inputTexture [[texture(1)]],
                       constant float4 *rectPointer [[buffer(0)]],
                       uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const float4 rect = float4(*rectPointer);
    const float minX = inputTexture.get_width() * rect.x;
    const float minY = inputTexture.get_height() * rect.y;
    constexpr sampler quadSampler(mag_filter::linear, min_filter::linear);
    const half4 outColor = inputTexture.sample(quadSampler, float2((gid.x + minX) / inputTexture.get_width(), (gid.y + minY) / inputTexture.get_height()));
    outputTexture.write(outColor, gid);
}
