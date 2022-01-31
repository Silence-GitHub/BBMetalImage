//
//  BBMetalRGBAFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/3/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void rgbaKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                       texture2d<half, access::read> inputTexture [[texture(1)]],
                       constant float *red [[buffer(0)]],
                       constant float *green [[buffer(1)]],
                       constant float *blue [[buffer(2)]],
                       constant float *alpha [[buffer(3)]],
                       uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const half4 inColor = inputTexture.read(gid);
    const half4 outColor(inColor.r * half(*red), inColor.g * half(*green), inColor.b * half(*blue), inColor.a * half(*alpha));
    outputTexture.write(outColor, gid);
}
