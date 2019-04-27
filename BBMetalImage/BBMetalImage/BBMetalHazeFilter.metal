//
//  BBMetalHazeFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/4/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void hazeKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                       texture2d<half, access::read> inputTexture [[texture(1)]],
                       constant float *hazeDistance [[buffer(0)]],
                       constant float *slope [[buffer(1)]],
                       uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const half4 white = half4(1.0);
    
    const half d = half(gid.y) / half(inputTexture.get_height()) * half(*slope) + half(*hazeDistance);
    
    half4 color = inputTexture.read(gid);
    color = (color - d * white) / (1.0 - d);
    
    outputTexture.write(color, gid);
}
