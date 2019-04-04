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
                                      device float3 *shadowTintColor [[buffer(0)]],
                                      device float *shadowTintIntensity [[buffer(1)]],
                                      device float3 *highlightTintColor [[buffer(2)]],
                                      device float *highlightTintIntensity [[buffer(3)]],
                                      uint2 gid [[thread_position_in_grid]]) {
    
    half4 inColor = inputTexture.read(gid);
    
    half luminance = dot(inColor.rgb, kLuminanceWeighting);
    
    half4 shadowResult = mix(inColor, max(inColor, half4(mix(half3(*shadowTintColor), inColor.rgb, luminance), inColor.a)), half(*shadowTintIntensity));
    half4 highlightResult = mix(inColor, min(shadowResult, half4(mix(shadowResult.rgb, half3(*highlightTintColor), luminance), inColor.a)), half(*highlightTintIntensity));
    
    half4 outColor(mix(shadowResult.rgb, highlightResult.rgb, luminance), inColor.a);
    outputTexture.write(outColor, gid);
}
