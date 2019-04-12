//
//  BBMetalNormalBlendFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void normalBlendKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                              texture2d<half, access::read> inputTexture [[texture(1)]],
                              texture2d<half, access::sample> inputTexture2 [[texture(2)]],
                              uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const half4 inColor2 = inputTexture.read(gid);
    
    constexpr sampler quadSampler;
    const half4 inColor = inputTexture2.sample(quadSampler, float2(float(gid.x) / outputTexture.get_width(), float(gid.y) / outputTexture.get_height()));
    
    half4 outColor;
    outColor.rgb = inColor.rgb + inColor2.rgb * inColor2.a * (1 - inColor.a);
    outColor.a = inColor.a + inColor2.a * (1 - inColor.a);
    outputTexture.write(outColor, gid);
}
