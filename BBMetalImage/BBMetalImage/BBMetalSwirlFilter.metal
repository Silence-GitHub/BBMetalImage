//
//  BBMetalSwirlFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/11/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void swirlKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                        texture2d<half, access::sample> inputTexture [[texture(1)]],
                        constant float2 *centerPointer [[buffer(0)]],
                        constant float *radiusPointer [[buffer(1)]],
                        constant float *anglePointer [[buffer(2)]],
                        uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const float2 center = float2(*centerPointer);
    const float radius = float(*radiusPointer);
    const float angle = float(*anglePointer);
    
    float2 textureCoordinateToUse = float2(float(gid.x) / outputTexture.get_width(), float(gid.y) / outputTexture.get_height());
    const float dist = distance(center, textureCoordinateToUse);
    
    if (dist < radius) {
        textureCoordinateToUse -= center;
        const float percent = (radius - dist) / radius;
        const float theta = percent * percent * angle * 8.0;
        const float s = sin(theta);
        const float c = cos(theta);
        textureCoordinateToUse = float2(dot(textureCoordinateToUse, float2(c, -s)), dot(textureCoordinateToUse, float2(s, c)));
        textureCoordinateToUse += center;
    }
    
    constexpr sampler quadSampler;
    const half4 outColor = inputTexture.sample(quadSampler, textureCoordinateToUse);
    outputTexture.write(outColor, gid);
}
