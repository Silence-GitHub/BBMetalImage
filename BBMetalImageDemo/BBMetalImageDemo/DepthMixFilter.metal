//
//  DepthMixFilter.metal
//  BBMetalImageDemo
//
//  Created by Kaibo Lu on 10/21/21.
//  Copyright © 2021 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct DepthRenderParameters {
    float offset;
    float range;
};

kernel void depthMixKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                           texture2d<half, access::read> originalTexture [[texture(1)]],
                           texture2d<half, access::read> effectTexture [[texture(2)]],
                           texture2d<half, access::sample> depthTexture [[texture(3)]],
                           constant DepthRenderParameters& converterParameters [[buffer(0)]],
                           constant float& depthThreshold [[buffer(1)]],
                           uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const half4 originalColor = originalTexture.read(gid);
    const half4 blurColor = effectTexture.read(gid);
    
    constexpr sampler quadSampler(mag_filter::linear, min_filter::linear);
    const float2 coordinate = float2(float(gid.x) / outputTexture.get_width(), float(gid.y) / outputTexture.get_height());
    half depth = depthTexture.sample(quadSampler, coordinate).x;
    depth = (depth - converterParameters.offset) / (converterParameters.range);
    depth = min(1.0, depth / depthThreshold);
    
    const half4 outColor = mix(blurColor, originalColor, depth);
    outputTexture.write(outColor, gid);
}
