//
//  BBMetalLevelsFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/8/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#define LevelsControlInputRange(color, minInput, maxInput) min(max(color - minInput, half3(0.0)) / (maxInput - minInput), half3(1.0))
#define LevelsControlInput(color, minInput, gamma, maxInput) GammaCorrection(LevelsControlInputRange(color, minInput, maxInput), gamma)
#define LevelsControlOutputRange(color, minOutput, maxOutput) mix(minOutput, maxOutput, color)
#define LevelsControl(color, minInput, gamma, maxInput, minOutput, maxOutput) LevelsControlOutputRange(LevelsControlInput(color, minInput, gamma, maxInput), minOutput, maxOutput)
#define GammaCorrection(color, gamma) pow(color, 1.0 / gamma)

kernel void  levelsKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                          texture2d<half, access::read> inputTexture [[texture(1)]],
                          constant float3 *minimum [[buffer(0)]],
                          constant float3 *middle [[buffer(1)]],
                          constant float3 *maximum [[buffer(2)]],
                          constant float3 *minOutput [[buffer(3)]],
                          constant float3 *maxOutput [[buffer(4)]],
                          uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const half4 inColor = inputTexture.read(gid);
    const half4 outColor(LevelsControl(inColor.rgb, half3(*minimum), half3(*middle), half3(*maximum), half3(*minOutput), half3(*maxOutput)), inColor.a);
    outputTexture.write(outColor, gid);
}
