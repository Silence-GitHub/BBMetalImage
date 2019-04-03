//
//  Luminance.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/1/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
#include "BBMetalShaderTypes.h"
using namespace metal;

kernel void luminanceKernel(texture2d<half, access::read> inputTexture [[texture(0)]],
                            texture2d<half, access::write> outputTexture [[texture(1)]],
                            uint2 gid [[thread_position_in_grid]]) {
    
    half4 inColor = inputTexture.read(gid);
    half luminance = dot(inColor.rgb, kLuminanceWeighting);
    outputTexture.write(half4(half3(luminance), inColor.a), gid);
}
