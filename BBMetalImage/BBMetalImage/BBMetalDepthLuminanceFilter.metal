//
//  BBMetalDepthLuminanceFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 10/21/21.
//  Copyright © 2021 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
#include "BBMetalShaderTypes.h"
using namespace metal;

kernel void depthLuminanceKernel(texture2d<float, access::write> outputTexture [[texture(0)]],
                                 texture2d<float, access::read> inputTexture [[texture(1)]],
                                 constant DepthRenderParameters& converterParameters [[buffer(0)]],
                                 uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    float depth = inputTexture.read(gid).x;
    
    // Normalize the value between 0 and 1.
    depth = (depth - converterParameters.offset) / (converterParameters.range);
    
    const float4 outputColor = float4(float3(depth), 1.0);
    
    outputTexture.write(outputColor, gid);
}
