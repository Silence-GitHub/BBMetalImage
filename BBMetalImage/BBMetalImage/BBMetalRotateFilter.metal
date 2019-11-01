//
//  BBMetalRotateFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/12/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
#include "BBMetalShaderTypes.h"
using namespace metal;

kernel void rotateKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                         texture2d<half, access::sample> inputTexture [[texture(1)]],
                         constant float *angle [[buffer(0)]],
                         uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const float outX = float(gid.x) - outputTexture.get_width() / 2.0f;
    const float outY = float(gid.y) - outputTexture.get_height() / 2.0f;
    const float d = distance(float2(outX, outY), float2(0, 0));
    float outAngle = atan(outY / outX);
    if (outX < 0) { outAngle += M_PI; }
    const float inAngle = outAngle - float(*angle);
    const float inX = (cos(inAngle) * d + inputTexture.get_width() / 2.0f) / inputTexture.get_width();
    const float inY = (sin(inAngle) * d + inputTexture.get_height() / 2.0f) / inputTexture.get_height();
    
    // Set empty pixel when out of range
    if (inX * inputTexture.get_width() < -1 ||
        inX * inputTexture.get_width() > inputTexture.get_width() + 1 ||
        inY * inputTexture.get_height() < -1 ||
        inY * inputTexture.get_height() > inputTexture.get_height() + 1) {
        outputTexture.write(half4(0), gid);
        return;
    }
    
    constexpr sampler quadSampler;
    const half4 color = inputTexture.sample(quadSampler, float2(inX, inY));
    outputTexture.write(color, gid);
}
