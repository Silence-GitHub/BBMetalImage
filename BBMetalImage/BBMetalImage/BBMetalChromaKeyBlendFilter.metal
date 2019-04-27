//
//  BBMetalChromaKeyBlendFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void chromaKeyBlendKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                                 texture2d<half, access::read> inputTexture [[texture(1)]],
                                 texture2d<half, access::sample> inputTexture2 [[texture(2)]],
                                 constant float *thresholdSensitivity [[buffer(0)]],
                                 constant float *smoothing [[buffer(1)]],
                                 constant float3 *colorToReplace [[buffer(2)]],
                                 uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const half4 textureColor = inputTexture.read(gid);
    constexpr sampler quadSampler;
    const half4 textureColor2 = inputTexture2.sample(quadSampler, float2(float(gid.x) / outputTexture.get_width(), float(gid.y) / outputTexture.get_height()));
    
    const half maskY = 0.2989h * float3(*colorToReplace).r + 0.5866h * float3(*colorToReplace).g + 0.1145h * float3(*colorToReplace).b;
    const half maskCr = 0.7132h * (float3(*colorToReplace).r - maskY);
    const half maskCb = 0.5647h * (float3(*colorToReplace).b - maskY);
    
    const half Y = 0.2989h * textureColor.r + 0.5866h * textureColor.g + 0.1145h * textureColor.b;
    const half Cr = 0.7132h * (textureColor.r - Y);
    const half Cb = 0.5647h * (textureColor.b - Y);
    
    const float blendValue = 1.0 - smoothstep(float(*thresholdSensitivity), float(*thresholdSensitivity) + float(*smoothing), distance(float2(Cr, Cb), float2(maskCr, maskCb)));
    const half4 outColor(mix(textureColor, textureColor2, half(blendValue)));
    outputTexture.write(outColor, gid);
}
