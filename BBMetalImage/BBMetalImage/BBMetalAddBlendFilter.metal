//
//  BBMetalAddBlendFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void addBlendKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                           texture2d<half, access::read> inputTexture [[texture(1)]],
                           texture2d<half, access::sample> inputTexture2 [[texture(2)]],
                           uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const half4 base = inputTexture.read(gid);
    constexpr sampler quadSampler;
    const half4 overlay = inputTexture2.sample(quadSampler, float2(float(gid.x) / outputTexture.get_width(), float(gid.y) / outputTexture.get_height()));
    
    half r;
    if (overlay.r * base.a + base.r * overlay.a >= overlay.a * base.a) {
        r = overlay.a * base.a + overlay.r * (1.0h - base.a) + base.r * (1.0h - overlay.a);
    } else {
        r = overlay.r + base.r;
    }
    
    half g;
    if (overlay.g * base.a + base.g * overlay.a >= overlay.a * base.a) {
        g = overlay.a * base.a + overlay.g * (1.0h - base.a) + base.g * (1.0h - overlay.a);
    } else {
        g = overlay.g + base.g;
    }
    
    half b;
    if (overlay.b * base.a + base.b * overlay.a >= overlay.a * base.a) {
        b = overlay.a * base.a + overlay.b * (1.0h- base.a) + base.b * (1.0h - overlay.a);
    } else {
        b = overlay.b + base.b;
    }
    
    const half a = overlay.a + base.a - overlay.a * base.a;
    
    const half4 outColor(r, g, b, a);
    outputTexture.write(outColor, gid);
}
