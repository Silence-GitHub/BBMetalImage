//
//  BBMetalLookupFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/2/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void lookupKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                         texture2d<half, access::read> inputTexture [[texture(1)]],
                         texture2d<half, access::sample> lookupTexture [[texture(2)]],
                         constant float *intensity [[buffer(0)]],
                         uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const half4 base = inputTexture.read(gid);
    
    const half blueColor = base.b * 63.0h;
    
    half2 quad1;
    quad1.y = floor(floor(blueColor) / 8.0h);
    quad1.x = floor(blueColor) - (quad1.y * 8.0h);
    
    half2 quad2;
    quad2.y = floor(ceil(blueColor) / 8.0h);
    quad2.x = ceil(blueColor) - (quad2.y * 8.0h);
    
    const float A = 0.125;
    const float B = 0.5 / 512.0;
    const float C = 0.125 - 1.0 / 512.0;
    
    float2 texPos1;
    texPos1.x = A * quad1.x + B + C * base.r;
    texPos1.y = A * quad1.y + B + C * base.g;
    
    float2 texPos2;
    texPos2.x = A * quad2.x + B + C * base.r;
    texPos2.y = A * quad2.y + B + C * base.g;
    
    constexpr sampler quadSampler;
    const half4 newColor1 = lookupTexture.sample(quadSampler, texPos1);
    const half4 newColor2 = lookupTexture.sample(quadSampler, texPos2);
    
    const half4 newColor = mix(newColor1, newColor2, fract(blueColor));
    const half4 outColor(mix(base, half4(newColor.rgb, base.a), half(*intensity)));
    
    outputTexture.write(outColor, gid);
}
