//
//  BBMetalHueFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/3/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

// Hue Constants
constant float4 kRGBToYPrime = float4(0.299, 0.587, 0.114, 0.0);
constant float4 kRGBToI = float4(0.595716, -0.274453, -0.321263, 0.0);
constant float4 kRGBToQ = float4(0.211456, -0.522591, 0.31135, 0.0);

constant float4 kYIQToR = float4(1.0, 0.9563, 0.6210, 0.0);
constant float4 kYIQToG = float4(1.0, -0.2721, -0.6474, 0.0);
constant float4 kYIQToB = float4(1.0, -1.1070, 1.7046, 0.0);

kernel void hueKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                      texture2d<half, access::read> inputTexture [[texture(1)]],
                      constant float *hueInput [[buffer(0)]],
                      uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    float4 color = float4(inputTexture.read(gid));
    
    // Convert to YIQ
    float YPrime = dot(color, kRGBToYPrime);
    float I = dot(color, kRGBToI);
    float Q = dot(color, kRGBToQ);
    
    // Calculate the hue and chroma
    float hue = atan2(Q, I);
    float chroma = sqrt(I * I + Q * Q);
    
    // Make the user's adjustments
    hue -= float(*hueInput); //why negative rotation?
    
    // Convert back to YIQ
    Q = chroma * sin(hue);
    I = chroma * cos(hue);
    
    // Convert back to RGB
    float4 yIQ = float4(YPrime, I, Q, 0.0);
    color.r = dot(yIQ, kYIQToR);
    color.g = dot(yIQ, kYIQToG);
    color.b = dot(yIQ, kYIQToB);
    
    outputTexture.write(half4(color), gid);
}
