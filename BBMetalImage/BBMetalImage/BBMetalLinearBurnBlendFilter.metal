//
//  BBMetalLinearBurnBlendFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/6/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void linearBurnBlendKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                                  texture2d<half, access::read> inputTexture [[texture(1)]],
                                  texture2d<half, access::sample> inputTexture2 [[texture(2)]],
                                  uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const half4 textureColor = inputTexture.read(gid);
    constexpr sampler quadSampler;
    const half4 textureColor2 = inputTexture2.sample(quadSampler, float2(float(gid.x) / outputTexture.get_width(), float(gid.y) / outputTexture.get_height()));
    
    const half4 outColor(clamp(textureColor.rgb + textureColor2.rgb - half3(1.0h), half3(0.0h), half3(1.0h)), textureColor.a);
    outputTexture.write(outColor, gid);
}
