//
//  BBMetalPolkaDotFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/10/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
#include "BBMetalShaderTypes.h"
using namespace metal;

kernel void polkaDotKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                           texture2d<half, access::sample> inputTexture [[texture(1)]],
                           constant float *fractionalWidth [[buffer(0)]],
                           constant float *dotScaling [[buffer(1)]],
                           uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    constexpr sampler quadSampler;
    const float fractionalWidthOfPixel = float(*fractionalWidth);
    const float aspectRatio = float(inputTexture.get_height()) / float(inputTexture.get_width());
    const float2 sampleDivisor = float2(fractionalWidthOfPixel, fractionalWidthOfPixel / aspectRatio);
    const float2 textureCoordinate = float2(float(gid.x) / outputTexture.get_width(), float(gid.y) / outputTexture.get_height());
    const float2 samplePos = textureCoordinate - mod(textureCoordinate, sampleDivisor) + 0.5 * sampleDivisor;
    const float2 textureCoordinateToUse = float2(textureCoordinate.x, (textureCoordinate.y * aspectRatio + 0.5 - 0.5 * aspectRatio));
    const float2 adjustedSamplePos = float2(samplePos.x, (samplePos.y * aspectRatio + 0.5 - 0.5 * aspectRatio));
    const float distanceFromSamplePoint = distance(adjustedSamplePos, textureCoordinateToUse);
    const float checkForPresenceWithinDot = step(distanceFromSamplePoint, (fractionalWidthOfPixel * 0.5) * float(*dotScaling));
    half4 outColor = inputTexture.sample(quadSampler, samplePos);
    outColor = half4(outColor.rgb * half(checkForPresenceWithinDot), outColor.a);
    outputTexture.write(outColor, gid);
}
