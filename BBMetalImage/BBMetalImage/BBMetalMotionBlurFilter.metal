//
//  BBMetalMotionBlurFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
#include "BBMetalShaderTypes.h"
using namespace metal;

kernel void motionBlurKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                             texture2d<half, access::sample> inputTexture [[texture(1)]],
                             constant float *blurSize [[buffer(0)]],
                             constant float *blurAngle [[buffer(1)]],
                             uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const float aspectRatio = float(inputTexture.get_height()) / float(inputTexture.get_width());
    float2 directionalTexelStep;
    directionalTexelStep.x = float(*blurSize) * cos(float(*blurAngle) * M_PI / 180.0) * aspectRatio / inputTexture.get_width();
    directionalTexelStep.y = float(*blurSize) * sin(float(*blurAngle) * M_PI / 180.0) / inputTexture.get_width();
    
    const float2 textureCoordinate = float2(float(gid.x) / outputTexture.get_width(), float(gid.y) / outputTexture.get_height());
    const float2 oneStepBackTextureCoordinate = textureCoordinate.xy - directionalTexelStep;
    const float2 twoStepsBackTextureCoordinate = textureCoordinate.xy - 2.0 * directionalTexelStep;
    const float2 threeStepsBackTextureCoordinate = textureCoordinate.xy - 3.0 * directionalTexelStep;
    const float2 fourStepsBackTextureCoordinate = textureCoordinate.xy - 4.0 * directionalTexelStep;
    const float2 oneStepForwardTextureCoordinate = textureCoordinate.xy + directionalTexelStep;
    const float2 twoStepsForwardTextureCoordinate = textureCoordinate.xy + 2.0 * directionalTexelStep;
    const float2 threeStepsForwardTextureCoordinate = textureCoordinate.xy + 3.0 * directionalTexelStep;
    const float2 fourStepsForwardTextureCoordinate = textureCoordinate.xy + 4.0 * directionalTexelStep;
    
    constexpr sampler quadSampler;
    half4 color = inputTexture.sample(quadSampler, textureCoordinate) * 0.18;
    
    color += inputTexture.sample(quadSampler, oneStepBackTextureCoordinate) * 0.15;
    color += inputTexture.sample(quadSampler, twoStepsBackTextureCoordinate) *  0.12;
    color += inputTexture.sample(quadSampler, threeStepsBackTextureCoordinate) * 0.09;
    color += inputTexture.sample(quadSampler, fourStepsBackTextureCoordinate) * 0.05;
    color += inputTexture.sample(quadSampler, oneStepForwardTextureCoordinate) * 0.15;
    color += inputTexture.sample(quadSampler, twoStepsForwardTextureCoordinate) *  0.12;
    color += inputTexture.sample(quadSampler, threeStepsForwardTextureCoordinate) * 0.09;
    color += inputTexture.sample(quadSampler, fourStepsForwardTextureCoordinate) * 0.05;
    
    outputTexture.write(color, gid);
}
