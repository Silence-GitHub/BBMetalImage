//
//  BBMetalHighlightShadowFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/3/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
#include "BBMetalShaderTypes.h"
using namespace metal;

kernel void highlightShadowKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                                  texture2d<half, access::read> inputTexture [[texture(1)]],
                                  constant float *shadows [[buffer(0)]],
                                  constant float *highlights [[buffer(1)]],
                                  uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const half4 inColor = inputTexture.read(gid);
    const half luminance = dot(inColor.rgb, kLuminanceWeighting);
    const half shadow = clamp((pow(luminance, 1.0h / (half(*shadows) + 1.0h)) + (-0.76) * pow(luminance, 2.0h / (half(*shadows) + 1.0h))) - luminance, 0.0, 1.0);
    const half highlight = clamp((1.0 - (pow(1.0 - luminance, 1.0 / (2.0 - half(*highlights))) + (-0.8) * pow(1.0 - luminance, 2.0 / (2.0 - half(*highlights))))) - luminance, -1.0, 0.0);
    const half3 result = half3(0.0, 0.0, 0.0) + ((luminance + shadow + highlight) - 0.0) * ((inColor.rgb - half3(0.0, 0.0, 0.0)) / (luminance - 0.0));
    
    const half4 outColor(result.rgb, inColor.a);
    outputTexture.write(outColor, gid);
}
