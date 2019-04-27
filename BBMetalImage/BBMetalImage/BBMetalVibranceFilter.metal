//
//  BBMetalVibranceFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/3/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void vibranceKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                           texture2d<half, access::read> inputTexture [[texture(1)]],
                           constant float *vibrance [[buffer(0)]],
                           uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    half4 color = inputTexture.read(gid);
    
    const half average = (color.r + color.g + color.b) / 3.0;
    const half mx = max(color.r, max(color.g, color.b));
    const half amt = (mx - average) * (-half(*vibrance) * 3.0);
    color.rgb = mix(color.rgb, half3(mx), amt);
    
    outputTexture.write(color, gid);
}
