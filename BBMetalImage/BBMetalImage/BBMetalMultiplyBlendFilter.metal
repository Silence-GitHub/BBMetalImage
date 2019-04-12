//
//  BBMetalMultiplyBlendFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void multiplyBlendKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                                texture2d<half, access::read> inputTexture [[texture(1)]],
                                texture2d<half, access::sample> inputTexture2 [[texture(2)]],
                                uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const half4 base = inputTexture.read(gid);
    constexpr sampler quadSampler;
    const half4 overlay = inputTexture2.sample(quadSampler, float2(float(gid.x) / outputTexture.get_width(), float(gid.y) / outputTexture.get_height()));
    
    const half4 outColor = overlay * base + overlay * (1.0h - base.a) + base * (1.0h - overlay.a);
    outputTexture.write(outColor, gid);
}
