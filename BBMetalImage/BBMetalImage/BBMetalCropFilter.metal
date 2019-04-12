//
//  BBMetalCropFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/11/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void cropKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                       texture2d<half, access::read> inputTexture [[texture(1)]],
                       device float4 *rectPointer [[buffer(0)]],
                       uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= inputTexture.get_width()) || (gid.y >= inputTexture.get_height())) { return; }
    
    const float4 rect = float4(*rectPointer);
    const uint minX = inputTexture.get_width() * rect.x;
    const uint minY = inputTexture.get_height() * rect.y;
    const uint maxX = inputTexture.get_width() * (rect.x + rect.z);
    const uint maxY = inputTexture.get_height() * (rect.y + rect.w);
    if (gid.x >= minX && gid.x < maxX && gid.y >= minY && gid.y < maxY) {
        const half4 outColor = inputTexture.read(gid);
        const uint2 outGid = uint2(gid.x - minX, gid.y - minY);
        outputTexture.write(outColor, outGid);
    }
}
