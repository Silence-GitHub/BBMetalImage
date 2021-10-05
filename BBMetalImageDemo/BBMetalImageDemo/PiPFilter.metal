//
//  PiPFilter.metal
//  BBMetalImageDemo
//
//  Created by Kaibo Lu on 10/5/21.
//  Copyright © 2021 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void pipKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                      texture2d<half, access::read> fullScreenInput [[texture(1)]],
                      texture2d<half, access::sample> pipInput [[texture(2)]],
                      constant float4 *pipFramePointer [[buffer(0)]],
                      uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const float4 pipFrame = *pipFramePointer;
    const float4 frame = float4(fullScreenInput.get_width() * pipFrame.x,
                                fullScreenInput.get_height() * pipFrame.y,
                                fullScreenInput.get_width() * pipFrame.z,
                                fullScreenInput.get_height() * pipFrame.w);
    
    half4 outColor;
    
    if ((gid.x >= frame.x) && (gid.x < frame.x + frame.z) &&
        (gid.y >= frame.y) && (gid.y < frame.y + frame.w)) {
        
        constexpr sampler quadSampler(mag_filter::linear, min_filter::linear);
        outColor = pipInput.sample(quadSampler, float2(float(gid.x - frame.x) / frame.z, float(gid.y - frame.y) / frame.w));
        
    } else {
        outColor = fullScreenInput.read(gid);
    }
    
    outputTexture.write(outColor, gid);
}
