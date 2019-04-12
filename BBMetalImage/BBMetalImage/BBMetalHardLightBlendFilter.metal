//
//  BBMetalHardLightBlendFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void hardLightBlendKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                                 texture2d<half, access::read> inputTexture [[texture(1)]],
                                 texture2d<half, access::sample> inputTexture2 [[texture(2)]],
                                 uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const half4 base = inputTexture.read(gid);
    constexpr sampler quadSampler;
    const half4 overlay = inputTexture2.sample(quadSampler, float2(float(gid.x) / outputTexture.get_width(), float(gid.y) / outputTexture.get_height()));
    
    half ra;
    if (2.0h * overlay.r < overlay.a) {
        ra = 2.0h * overlay.r * base.r + overlay.r * (1.0h - base.a) + base.r * (1.0h - overlay.a);
    } else {
        ra = overlay.a * base.a - 2.0h * (base.a - base.r) * (overlay.a - overlay.r) + overlay.r * (1.0h - base.a) + base.r * (1.0h - overlay.a);
    }
    
    half ga;
    if (2.0h * overlay.g < overlay.a) {
        ga = 2.0h * overlay.g * base.g + overlay.g * (1.0h - base.a) + base.g * (1.0h - overlay.a);
    } else {
        ga = overlay.a * base.a - 2.0h * (base.a - base.g) * (overlay.a - overlay.g) + overlay.g * (1.0h - base.a) + base.g * (1.0h - overlay.a);
    }
    
    half ba;
    if (2.0h * overlay.b < overlay.a) {
        ba = 2.0h * overlay.b * base.b + overlay.b * (1.0h - base.a) + base.b * (1.0h - overlay.a);
    } else {
        ba = overlay.a * base.a - 2.0h * (base.a - base.b) * (overlay.a - overlay.b) + overlay.b * (1.0h - base.a) + base.b * (1.0h - overlay.a);
    }
    
    const half4 outColor(ra, ga, ba, 1.0h);
    outputTexture.write(outColor, gid);
}
