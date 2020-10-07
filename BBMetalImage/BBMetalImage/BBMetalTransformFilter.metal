//
//  BBMetalTransformFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 10/6/20.
//  Copyright © 2020 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void transformKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                            texture2d<half, access::sample> inputTexture [[texture(1)]],
                            constant float3x2 *matrix [[buffer(0)]],
                            uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const float outX = float(gid.x) / outputTexture.get_width();
    const float outY = float(gid.y) / outputTexture.get_height();
    
    const float3x2 m = *matrix;
    const float a = m[0][0], b = m[0][1];
    const float c = m[1][0], d = m[1][1];
    
    if (a * d - b * c == 0 || b * c - a * d == 0) {
        outputTexture.write(half4(0), gid);
        return;
    }
    
    const float tx = m[2][0] / outputTexture.get_width(), ty = m[2][1] / outputTexture.get_height();
    
    const float inX = (d * outX - c * outY - d * tx + c * ty) / (a * d - b * c);
    const float inY = (b * outX - a * outY - b * tx + a * ty) / (b * c - a * d);
    
    // Set empty pixel when out of range
    if (inX * inputTexture.get_width() < -1 ||
        inX * inputTexture.get_width() > inputTexture.get_width() + 1 ||
        inY * inputTexture.get_height() < -1 ||
        inY * inputTexture.get_height() > inputTexture.get_height() + 1) {
        outputTexture.write(half4(0), gid);
        return;
    }
    
    constexpr sampler quadSampler(mag_filter::linear, min_filter::linear);
    const half4 color = inputTexture.sample(quadSampler, float2(inX, inY));
    outputTexture.write(color, gid);
}
