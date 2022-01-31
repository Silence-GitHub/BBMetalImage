//
//  BBMetalPosterizeFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/11/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void posterizeKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                            texture2d<half, access::read> inputTexture [[texture(1)]],
                            constant float *colorLevelsPointer [[buffer(0)]],
                            uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const half4 inColor = inputTexture.read(gid);
    const half colorLevels = half(*colorLevelsPointer);
    const half4 outColor = floor((inColor * colorLevels) + half4(0.5)) / colorLevels;
    outputTexture.write(outColor, gid);
}
