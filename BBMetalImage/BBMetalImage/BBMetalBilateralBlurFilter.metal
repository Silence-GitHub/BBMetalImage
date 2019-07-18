//
//  BBMetalBilateralBlurFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 2019/7/17.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void bilateralBlurKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                                texture2d<half, access::sample> inputTexture [[texture(1)]],
                                constant float *distanceNormalizationFactorPointer [[buffer(0)]],
                                constant float *stepOffsetX [[buffer(1)]],
                                constant float *stepOffsetY [[buffer(2)]],
                                uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const int GAUSSIAN_SAMPLES = 9;
    
    const float x = float(gid.x);
    const float y = float(gid.y);
    const float width = float(inputTexture.get_width());
    const float height = float(inputTexture.get_height());
    const float2 inCoordinate(x / width, y / height);
    
    int multiplier = 0;
    float2 blurStep;
    float2 singleStepOffset(float(*stepOffsetX) / width, float(*stepOffsetY) / height);
    float2 blurCoordinates[GAUSSIAN_SAMPLES];
    
    for (int i = 0; i < GAUSSIAN_SAMPLES; i++) {
        multiplier = (i - ((GAUSSIAN_SAMPLES - 1) / 2));
        blurStep = float(multiplier) * singleStepOffset;
        blurCoordinates[i] = inCoordinate + blurStep;
    }
    
    half4 centralColor;
    half gaussianWeightTotal;
    half4 sum;
    half4 sampleColor;
    half distanceFromCentralColor;
    half gaussianWeight;
    
    constexpr sampler quadSampler;
    const float distanceNormalizationFactor = float(*distanceNormalizationFactorPointer);
    
    centralColor = inputTexture.sample(quadSampler, blurCoordinates[4]);
    gaussianWeightTotal = 0.18;
    sum = centralColor * 0.18;
    
    sampleColor = inputTexture.sample(quadSampler, blurCoordinates[0]);
    distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
    gaussianWeight = 0.05 * (1.0 - distanceFromCentralColor);
    gaussianWeightTotal += gaussianWeight;
    sum += sampleColor * gaussianWeight;
    
    sampleColor = inputTexture.sample(quadSampler, blurCoordinates[1]);
    distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
    gaussianWeight = 0.09 * (1.0 - distanceFromCentralColor);
    gaussianWeightTotal += gaussianWeight;
    sum += sampleColor * gaussianWeight;
    
    sampleColor = inputTexture.sample(quadSampler, blurCoordinates[2]);
    distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
    gaussianWeight = 0.12 * (1.0 - distanceFromCentralColor);
    gaussianWeightTotal += gaussianWeight;
    sum += sampleColor * gaussianWeight;
    
    sampleColor = inputTexture.sample(quadSampler, blurCoordinates[3]);
    distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
    gaussianWeight = 0.15 * (1.0 - distanceFromCentralColor);
    gaussianWeightTotal += gaussianWeight;
    sum += sampleColor * gaussianWeight;
    
    sampleColor = inputTexture.sample(quadSampler, blurCoordinates[5]);
    distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
    gaussianWeight = 0.15 * (1.0 - distanceFromCentralColor);
    gaussianWeightTotal += gaussianWeight;
    sum += sampleColor * gaussianWeight;
    
    sampleColor = inputTexture.sample(quadSampler, blurCoordinates[6]);
    distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
    gaussianWeight = 0.12 * (1.0 - distanceFromCentralColor);
    gaussianWeightTotal += gaussianWeight;
    sum += sampleColor * gaussianWeight;
    
    sampleColor = inputTexture.sample(quadSampler, blurCoordinates[7]);
    distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
    gaussianWeight = 0.09 * (1.0 - distanceFromCentralColor);
    gaussianWeightTotal += gaussianWeight;
    sum += sampleColor * gaussianWeight;
    
    sampleColor = inputTexture.sample(quadSampler, blurCoordinates[8]);
    distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
    gaussianWeight = 0.05 * (1.0 - distanceFromCentralColor);
    gaussianWeightTotal += gaussianWeight;
    sum += sampleColor * gaussianWeight;
    
    const half4 outColor = sum / gaussianWeightTotal;
    outputTexture.write(outColor, gid);
}
