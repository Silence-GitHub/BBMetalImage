//
//  BBMetalPinchFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 8/16/20.
//  Copyright © 2020 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void pinchKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                        texture2d<half, access::sample> inputTexture [[texture(1)]],
                        constant float2 *centerPointer [[buffer(0)]],
                        constant float *radiusPointer [[buffer(1)]],
                        constant float *scalePointer [[buffer(2)]],
                        uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const float2 center = float2(*centerPointer);
    const float radius = float(*radiusPointer);
    const float scale = float(*scalePointer);
    const float aspectRatio = float(inputTexture.get_height()) / float(inputTexture.get_width());
    
    const float2 inCoordinateToUse = float2(float(gid.x) / outputTexture.get_width(), float(gid.y) / outputTexture.get_height());
    float2 textureCoordinateToUse = float2(inCoordinateToUse.x, inCoordinateToUse.y * aspectRatio + 0.5 - 0.5 * aspectRatio);
    const float dist = distance(center, textureCoordinateToUse);
    textureCoordinateToUse = inCoordinateToUse;
    
    if (dist < radius) {
        textureCoordinateToUse -= center;
        float percent = 1.0 + (0.5 - dist) / 0.5 * scale;
        textureCoordinateToUse = textureCoordinateToUse * percent + center;
    }
    
    constexpr sampler quadSampler(mag_filter::linear, min_filter::linear);
    const half4 outColor = inputTexture.sample(quadSampler, textureCoordinateToUse);
    outputTexture.write(outColor, gid);
}
