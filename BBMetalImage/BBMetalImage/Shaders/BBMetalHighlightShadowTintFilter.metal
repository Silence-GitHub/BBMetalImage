//
//  BBMetalHighlightShadowTintFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/3/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
#include "BBMetalShaderTypes.h"
using namespace metal;

kernel void highlightShadowTintKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                                      texture2d<half, access::read> inputTexture [[texture(1)]],
                                      constant float3 *shadowTintColor [[buffer(0)]],
                                      constant float *shadowTintIntensity [[buffer(1)]],
                                      constant float3 *highlightTintColor [[buffer(2)]],
                                      constant float *highlightTintIntensity [[buffer(3)]],
                                      uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const half4 inColor = inputTexture.read(gid);
    
    const half luminance = dot(inColor.rgb, kLuminanceWeighting);
    
    const half4 shadowResult = mix(inColor, max(inColor, half4(mix(half3(*shadowTintColor), inColor.rgb, luminance), inColor.a)), half(*shadowTintIntensity));
    const half4 highlightResult = mix(inColor, min(shadowResult, half4(mix(shadowResult.rgb, half3(*highlightTintColor), luminance), inColor.a)), half(*highlightTintIntensity));
    
    const half4 outColor(mix(shadowResult.rgb, highlightResult.rgb, luminance), inColor.a);
    outputTexture.write(outColor, gid);
}
