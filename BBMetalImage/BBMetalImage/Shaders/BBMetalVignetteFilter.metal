//
//  BBMetalVignetteFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 8/16/20.
//  Copyright © 2020 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void vignetteKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                           texture2d<half, access::read> inputTexture [[texture(1)]],
                           constant float2 *center [[buffer(0)]],
                           constant float3 *color [[buffer(1)]],
                           constant float *start [[buffer(2)]],
                           constant float *end [[buffer(3)]],
                           uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const half4 inColor = inputTexture.read(gid);
    const float d = distance(float2(float(gid.x) / outputTexture.get_width(), float(gid.y) / outputTexture.get_height()), *center);
    const half percent = smoothstep(*start, *end, d);
    const half4 outColor = half4(mix(inColor.rgb, half3(*color), percent), inColor.a);
    outputTexture.write(outColor, gid);
}
