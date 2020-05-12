//
//  BBMetalChromaKeyFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/4/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void chromaKeyKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                            texture2d<half, access::read> inputTexture [[texture(1)]],
                            constant float *thresholdSensitivity [[buffer(0)]],
                            constant float *smoothing [[buffer(1)]],
                            constant float3 *colorToReplace [[buffer(2)]],
                            uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const half4 inColor = inputTexture.read(gid);
    
    const half maskY = 0.2989h * float3(*colorToReplace).r + 0.5866h * float3(*colorToReplace).g + 0.1145h * float3(*colorToReplace).b;
    const half maskCr = 0.7132h * (float3(*colorToReplace).r - maskY);
    const half maskCb = 0.5647h * (float3(*colorToReplace).b - maskY);
    
    const half Y = 0.2989h * inColor.r + 0.5866h * inColor.g + 0.1145h * inColor.b;
    const half Cr = 0.7132h * (inColor.r - Y);
    const half Cb = 0.5647h * (inColor.b - Y);
    
    const half blendValue = smoothstep(half(*thresholdSensitivity), half(*thresholdSensitivity + *smoothing), distance(half2(Cr, Cb), half2(maskCr, maskCb)));
    
    const half4 outColor(inColor * blendValue);
    outputTexture.write(outColor, gid);
}
