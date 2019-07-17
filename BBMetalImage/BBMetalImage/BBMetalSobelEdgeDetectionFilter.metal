//
//  BBMetalSobelEdgeDetectionFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 7/17/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void sobelEdgeDetectionKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                                     texture2d<half, access::sample> inputTexture [[texture(1)]],
                                     constant float *edgeStrength [[buffer(0)]],
                                     uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const float x = float(gid.x);
    const float y = float(gid.y);
    const float width = float(inputTexture.get_width());
    const float height = float(inputTexture.get_height());
    
    const float2 leftCoordinate = float2((x - 1) / width, y / height);
    const float2 rightCoordinate = float2((x + 1) / width, y / height);
    const float2 topCoordinate = float2(x / width, (y - 1) / height);
    const float2 bottomCoordinate = float2(x / width, (y + 1) / height);
    const float2 topLeftCoordinate = float2((x - 1) / width, (y - 1) / height);
    const float2 topRightCoordinate = float2((x + 1) / width, (y - 1) / height);
    const float2 bottomLeftCoordinate = float2((x - 1) / width, (y + 1) / height);
    const float2 bottomRightCoordinate = float2((x + 1) / width, (y + 1) / height);
    
    constexpr sampler quadSampler;
    
    const half leftIntensity = inputTexture.sample(quadSampler, leftCoordinate).r;
    const half rightIntensity = inputTexture.sample(quadSampler, rightCoordinate).r;
    const half topIntensity = inputTexture.sample(quadSampler, topCoordinate).r;
    const half bottomIntensity = inputTexture.sample(quadSampler, bottomCoordinate).r;
    const half topLeftIntensity = inputTexture.sample(quadSampler, topLeftCoordinate).r;
    const half topRightIntensity = inputTexture.sample(quadSampler, topRightCoordinate).r;
    const half bottomLeftIntensity = inputTexture.sample(quadSampler, bottomLeftCoordinate).r;
    const half bottomRightIntensity = inputTexture.sample(quadSampler, bottomRightCoordinate).r;
    
    const half h = -topLeftIntensity - 2.0h * topIntensity - topRightIntensity + bottomLeftIntensity + 2.0h * bottomIntensity + bottomRightIntensity;
    const half v = -bottomLeftIntensity - 2.0h * leftIntensity - topLeftIntensity + bottomRightIntensity + 2.0h * rightIntensity + topRightIntensity;
    
    const half mag = length(half2(h, v)) * half(*edgeStrength);
    const half4 outColor(half3(mag), 1.0h);
    outputTexture.write(outColor, gid);
}
