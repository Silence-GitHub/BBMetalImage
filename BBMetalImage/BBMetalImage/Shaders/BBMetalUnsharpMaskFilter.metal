//
//  BBMetalUnsharpMaskFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/11/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void unsharpMaskKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                              texture2d<half, access::read> blurTexture [[texture(1)]],
                              texture2d<half, access::read> inputTexture [[texture(2)]],
                              constant float *intensity [[buffer(0)]],
                              uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const half4 inColor = inputTexture.read(gid);
    const half4 blurColor = blurTexture.read(gid);
    const half4 outColor(inColor.rgb * half(*intensity) + blurColor.rgb * (1.0 - half(*intensity)), inColor.a);
    outputTexture.write(outColor, gid);
}
