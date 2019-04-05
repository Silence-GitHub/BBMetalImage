//
//  BBMetalSharpenFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/4/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void sharpenKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                          texture2d<half, access::read> inputTexture [[texture(1)]],
                          device float *sharpeness [[buffer(0)]],
                          uint2 gid [[thread_position_in_grid]]) {
    
    const half4 inColor = inputTexture.read(gid);
    
    if (gid.x < 1 || gid.x >= inputTexture.get_width() - 1 || gid.y < 1 || gid.y >= inputTexture.get_height() - 1) {
        outputTexture.write(inColor, gid);
        return;
    }
    
    const half4 leftColor = inputTexture.read(uint2(gid.x - 1, gid.y));
    const half4 rightColor = inputTexture.read(uint2(gid.x + 1, gid.y));
    const half4 topColor = inputTexture.read(uint2(gid.x, gid.y + 1));
    const half4 bottomColor = inputTexture.read(uint2(gid.x, gid.y - 1));
    
    const half centerMultiplier = 1.0 + 4.0 * half(*sharpeness);
    const half edgeMultiplier = half(*sharpeness);
    const half4 outColor((inColor.rgb * centerMultiplier - (leftColor.rgb + rightColor.rgb + topColor.rgb + bottomColor.rgb) * edgeMultiplier), bottomColor.a);
    outputTexture.write(outColor, gid);
}
