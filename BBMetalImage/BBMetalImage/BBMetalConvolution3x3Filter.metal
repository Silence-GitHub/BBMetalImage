//
//  BBMetalConvolution3x3Filter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 11/22/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void convolution3x3Kernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                                 texture2d<half, access::sample> inputTexture [[texture(1)]],
                                 constant float3x3 *convolution [[buffer(0)]],
                                 uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const float x = float(gid.x);
    const float y = float(gid.y);
    const float width = float(inputTexture.get_width());
    const float height = float(inputTexture.get_height());
    
    const float2 centerCoordinate = float2(x / width, y / height);
    const float2 leftCoordinate = float2((x - 1) / width, y / height);
    const float2 rightCoordinate = float2((x + 1) / width, y / height);
    const float2 topCoordinate = float2(x / width, (y - 1) / height);
    const float2 bottomCoordinate = float2(x / width, (y + 1) / height);
    const float2 topLeftCoordinate = float2((x - 1) / width, (y - 1) / height);
    const float2 topRightCoordinate = float2((x + 1) / width, (y - 1) / height);
    const float2 bottomLeftCoordinate = float2((x - 1) / width, (y + 1) / height);
    const float2 bottomRightCoordinate = float2((x + 1) / width, (y + 1) / height);
    
    constexpr sampler quadSampler;
    
    const half4 centerColor = inputTexture.sample(quadSampler, centerCoordinate);
    
    const half3 leftColor = inputTexture.sample(quadSampler, leftCoordinate).rgb;
    const half3 rightColor = inputTexture.sample(quadSampler, rightCoordinate).rgb;
    const half3 topColor = inputTexture.sample(quadSampler, topCoordinate).rgb;
    const half3 bottomColor = inputTexture.sample(quadSampler, bottomCoordinate).rgb;
    const half3 topLeftColor = inputTexture.sample(quadSampler, topLeftCoordinate).rgb;
    const half3 topRightColor = inputTexture.sample(quadSampler, topRightCoordinate).rgb;
    const half3 bottomLeftColor = inputTexture.sample(quadSampler, bottomLeftCoordinate).rgb;
    const half3 bottomRightColor = inputTexture.sample(quadSampler, bottomRightCoordinate).rgb;
    
    const float3x3 convolutionMatrix = *convolution;
    half3 resultColor = topLeftColor * convolutionMatrix[0][0] + topColor * convolutionMatrix[0][1] + topRightColor * convolutionMatrix[0][2];
    resultColor += leftColor * convolutionMatrix[1][0] + centerColor.rgb * convolutionMatrix[1][1] + rightColor * convolutionMatrix[1][2];
    resultColor += bottomLeftColor * convolutionMatrix[2][0] + bottomColor * convolutionMatrix[2][1] + bottomRightColor * convolutionMatrix[2][2];
    
    outputTexture.write(half4(resultColor, centerColor.a), gid);
}
