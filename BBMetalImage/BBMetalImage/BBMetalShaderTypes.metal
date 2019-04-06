//
//  BBMetalBlendShaderTypes.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

half lum(half3 c) {
    return dot(c, half3(0.3, 0.59, 0.11));
}

half3 clipcolor(half3 c) {
    half l = lum(c);
    half n = min(min(c.r, c.g), c.b);
    half x = max(max(c.r, c.g), c.b);
    
    if (n < 0.0h) {
        c.r = l + ((c.r - l) * l) / (l - n);
        c.g = l + ((c.g - l) * l) / (l - n);
        c.b = l + ((c.b - l) * l) / (l - n);
    }
    if (x > 1.0h) {
        c.r = l + ((c.r - l) * (1.0h - l)) / (x - l);
        c.g = l + ((c.g - l) * (1.0h - l)) / (x - l);
        c.b = l + ((c.b - l) * (1.0h - l)) / (x - l);
    }
    
    return c;
}

half3 setlum(half3 c, half l) {
    half d = l - lum(c);
    c = c + half3(d);
    return clipcolor(c);
}
