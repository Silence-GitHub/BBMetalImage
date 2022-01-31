//
//  BBMetalTiltShiftFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/11/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void tiltShiftKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                            texture2d<half, access::read> blurTexture [[texture(1)]],
                            texture2d<half, access::read> inputTexture [[texture(2)]],
                            constant float *topFocusLevelPointer [[buffer(0)]],
                            constant float *bottomFocusLevelPointer [[buffer(1)]],
                            constant float *focusFallOffRatePointer [[buffer(2)]],
                            uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const half4 inColor = inputTexture.read(gid);
    const half4 blurColor = blurTexture.read(gid);
    
    const float topFocusLevel = float(*topFocusLevelPointer);
    const float bottomFocusLevel = float(*bottomFocusLevelPointer);
    const float focusFallOffRate = float(*focusFallOffRatePointer);
    
    const float y = float(gid.y) / float(blurTexture.get_height());
    float blurIntensity = 1.0 - smoothstep(topFocusLevel - focusFallOffRate, topFocusLevel, y);
    blurIntensity += smoothstep(bottomFocusLevel, bottomFocusLevel + focusFallOffRate, y);
    
    const half4 outColor = mix(inColor, blurColor, blurIntensity);
    outputTexture.write(outColor, gid);
}
