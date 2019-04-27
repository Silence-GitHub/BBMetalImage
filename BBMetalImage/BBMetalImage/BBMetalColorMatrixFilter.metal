//
//  BBMetalColorMatrixFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/8/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void colorMatrixKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                              texture2d<half, access::read> inputTexture [[texture(1)]],
                              constant float *intensity [[buffer(0)]],
                              constant float4x4 *colorMatrix [[buffer(1)]],
                              uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const half4 inColor = inputTexture.read(gid);
    half4 outColor = inColor * half4x4(*colorMatrix);
    outColor = half(*intensity) * outColor + (1.0 - half(*intensity)) * inColor;
    outputTexture.write(outColor, gid);
}
