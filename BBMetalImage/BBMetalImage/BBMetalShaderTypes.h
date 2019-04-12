//
//  BBMetalShaderTypes.h
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/1/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#ifndef BBMetalShaderTypes_h
#define BBMetalShaderTypes_h

#define M_PI 3.14159265358979323846264338327950288

// Luminance Constants
constant half3 kLuminanceWeighting = half3(0.2125, 0.7154, 0.0721); // Values from "Graphics Shaders: Theory and Practice" by Bailey and Cunningham

half lum(half3 c);

half3 clipcolor(half3 c);

half3 setlum(half3 c, half l);

half sat(half3 c);

half mid(half cmin, half cmid, half cmax, half s);

half3 setsat(half3 c, half s);

float mod(float x, float y);

float2 mod(float2 x, float2 y);

#endif /* BBMetalShaderTypes_h */
