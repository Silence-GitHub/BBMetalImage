//
//  BBMetalWhiteBalanceFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/3/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

constant half3 warmFilter = half3(0.93, 0.54, 0.0);

kernel void whiteBalanceKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                               texture2d<half, access::read> inputTexture [[texture(1)]],
                               constant float *temperature [[buffer(0)]],
                               constant float *tint [[buffer(1)]],
                               uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const half4 inColor = inputTexture.read(gid);
    
    const half3x3 RGBtoYIQ = half3x3(half3(0.299, 0.587, 0.114), half3(0.596, -0.274, -0.322), half3(0.212, -0.523, 0.311));
    const half3x3 YIQtoRGB = half3x3(half3(1.0, 0.956, 0.621), half3(1.0, -0.272, -0.647), half3(1.0, -1.105, 1.702));
    
    half3 yiq = RGBtoYIQ * inColor.rgb;
    yiq.b = clamp(yiq.b + half(*tint) * 0.5226 * 0.1, -0.5226, 0.5226);
    const half3 rgb = YIQtoRGB * yiq;
    
    const half3 processed = half3((rgb.r < 0.5 ? (2.0 * rgb.r * warmFilter.r) : (1.0 - 2.0 * (1.0 - rgb.r) * (1.0 - warmFilter.r))),
                                  (rgb.g < 0.5 ? (2.0 * rgb.g * warmFilter.g) : (1.0 - 2.0 * (1.0 - rgb.g) * (1.0 - warmFilter.g))),
                                  (rgb.b < 0.5 ? (2.0 * rgb.b * warmFilter.b) : (1.0 - 2.0 * (1.0 - rgb.b) * (1.0 - warmFilter.b))));
    
    const half4 outColor(mix(rgb, processed, half(*temperature)), inColor.a);
    outputTexture.write(outColor, gid);
}
