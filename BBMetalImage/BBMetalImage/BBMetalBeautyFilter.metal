//
//  BBMetalBeautyFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 7/17/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void beautyCombinationKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                                    texture2d<half, access::read> blurTexture [[texture(1)]],
                                    texture2d<half, access::read> edgeTexture [[texture(2)]],
                                    texture2d<half, access::read> originTexture [[texture(3)]],
                                    constant float *smoothDegree [[buffer(0)]],
                                    uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }
    
    const half4 blur = blurTexture.read(gid);
    const half4 edge = edgeTexture.read(gid);
    const half4 origin = originTexture.read(gid);
    
    const half r = origin.r;
    const half g = origin.g;
    const half b = origin.b;
    
    half4 smooth;
    if (edge.r < 0.2 && r > 0.3725 && g > 0.1568 && b > 0.0784 && r > g && r > b && r - min(g, b) > 0.0588 && r - g > 0.0588) {
        // Skin detection method
        // https://blog.csdn.net/Trent1985/article/details/50496969
        smooth = (1.0 - half(*smoothDegree)) * origin + half(*smoothDegree) * blur;
    } else {
        smooth = origin;
    }
    smooth.r = log(1.0 + 0.2 * smooth.r) / log(1.2);
    smooth.g = log(1.0 + 0.2 * smooth.g) / log(1.2);
    smooth.b = log(1.0 + 0.2 * smooth.b) / log(1.2);
    outputTexture.write(smooth, gid);
}
