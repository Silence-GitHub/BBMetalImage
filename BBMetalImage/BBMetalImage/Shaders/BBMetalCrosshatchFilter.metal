//
//  BBMetalCrosshatchFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/10/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
#include "BBMetalShaderTypes.h"
using namespace metal;

kernel void crosshatchKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                             texture2d<half, access::read> inputTexture [[texture(1)]],
                             constant float *crossHatchSpacingPointer [[buffer(0)]],
                             constant float *lineWidthPointer [[buffer(1)]],
                             uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const float2 textureCoordinate = float2(float(gid.x) / outputTexture.get_width(), float(gid.y) / outputTexture.get_height());
    const float crossHatchSpacing = float(*crossHatchSpacingPointer);
    const float lineWidth = float(*lineWidthPointer);
    
    const half4 color = inputTexture.read(gid);
    const half luminance = dot(color.rgb, kLuminanceWeighting);
    
    const bool displayBlack = ((luminance < 1.00) && (mod(textureCoordinate.x + textureCoordinate.y, crossHatchSpacing) <= lineWidth)) ||
    ((luminance < 0.75) && (mod(textureCoordinate.x - textureCoordinate.y, crossHatchSpacing) <= lineWidth)) ||
    ((luminance < 0.50) && (mod(textureCoordinate.x + textureCoordinate.y - (crossHatchSpacing / 2.0), crossHatchSpacing) <= lineWidth)) ||
    ((luminance < 0.3) && (mod(textureCoordinate.x - textureCoordinate.y - (crossHatchSpacing / 2.0), crossHatchSpacing) <= lineWidth));
    
    const half4 outColor = displayBlack ? half4(0.0, 0.0, 0.0, 1.0) : half4(1.0);
    outputTexture.write(outColor, gid);
}
