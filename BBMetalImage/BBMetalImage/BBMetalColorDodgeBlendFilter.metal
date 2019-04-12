//
//  BBMetalColorDodgeBlendFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void colorDodgeBlendKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                                  texture2d<half, access::read> inputTexture [[texture(1)]],
                                  texture2d<half, access::sample> inputTexture2 [[texture(2)]],
                                  uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const half4 base = inputTexture.read(gid);
    constexpr sampler quadSampler;
    const half4 overlay = inputTexture2.sample(quadSampler, float2(float(gid.x) / outputTexture.get_width(), float(gid.y) / outputTexture.get_height()));
    
    const half3 baseOverlayAlphaProduct = half3(overlay.a * base.a);
    const half3 rightHandProduct = overlay.rgb * (1.0h - base.a) + base.rgb * (1.0h - overlay.a);
    
    const half3 firstBlendColor = baseOverlayAlphaProduct + rightHandProduct;
    const half3 overlayRGB = clamp((overlay.rgb / clamp(overlay.a, 0.01h, 1.0h)) * step(0.0h, overlay.a), 0.0h, 0.99h);
    
    const half3 secondBlendColor = (base.rgb * overlay.a) / (1.0h - overlayRGB) + rightHandProduct;
    
    const half3 colorChoice = step((overlay.rgb * base.a + base.rgb * overlay.a), baseOverlayAlphaProduct);
    
    const half4 outColor(mix(firstBlendColor, secondBlendColor, colorChoice), 1.0h);
    outputTexture.write(outColor, gid);
}
