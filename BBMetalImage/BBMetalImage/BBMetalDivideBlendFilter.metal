//
//  BBMetalDivideBlendFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void divideBlendKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                              texture2d<half, access::read> inputTexture [[texture(1)]],
                              texture2d<half, access::sample> inputTexture2 [[texture(2)]],
                              uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const half4 base = inputTexture.read(gid);
    constexpr sampler quadSampler;
    const half4 overlay = inputTexture2.sample(quadSampler, float2(float(gid.x) / outputTexture.get_width(), float(gid.y) / outputTexture.get_height()));
    
    half ra;
    if (overlay.a == 0.0h || ((base.r / overlay.r) > (base.a / overlay.a)))
        ra = overlay.a * base.a + overlay.r * (1.0h - base.a) + base.r * (1.0h - overlay.a);
    else
        ra = (base.r * overlay.a * overlay.a) / overlay.r + overlay.r * (1.0h - base.a) + base.r * (1.0h - overlay.a);
    
    half ga;
    if (overlay.a == 0.0h || ((base.g / overlay.g) > (base.a / overlay.a)))
        ga = overlay.a * base.a + overlay.g * (1.0h - base.a) + base.g * (1.0h - overlay.a);
    else
        ga = (base.g * overlay.a * overlay.a) / overlay.g + overlay.g * (1.0h - base.a) + base.g * (1.0h - overlay.a);
    
    half ba;
    if (overlay.a == 0.0h || ((base.b / overlay.b) > (base.a / overlay.a)))
        ba = overlay.a * base.a + overlay.b * (1.0h - base.a) + base.b * (1.0h - overlay.a);
    else
        ba = (base.b * overlay.a * overlay.a) / overlay.b + overlay.b * (1.0h - base.a) + base.b * (1.0h - overlay.a);
    
    const half a = overlay.a + base.a - overlay.a * base.a;
    
    const half4 outColor(ra, ga, ba, a);
    outputTexture.write(outColor, gid);
}
