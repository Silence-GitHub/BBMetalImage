//
//  TwoHalfFilter.metal
//  BBMetalImageDemo
//
//  Created by Kaibo Lu on 7/25/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void twoHalfKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                          texture2d<half, access::read> leftTexture [[texture(1)]],
                          texture2d<half, access::read> rightTexture [[texture(2)]],
                          uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    half4 outColor;
    if (gid.x <= outputTexture.get_width() / 2) {
        outColor = leftTexture.read(gid);
    } else {
        outColor = rightTexture.read(gid);
    }
    outputTexture.write(outColor, gid);
}

