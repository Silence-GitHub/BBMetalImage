//
//  BBMetalShaderTypes.h
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/1/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#ifndef BBMetalShaderTypes_h
#define BBMetalShaderTypes_h

// Luminance Constants
constant half3 kLuminanceWeighting = half3(0.2125, 0.7154, 0.0721); // Values from "Graphics Shaders: Theory and Practice" by Bailey and Cunningham

half lum(half3 c);

half3 clipcolor(half3 c);

half3 setlum(half3 c, half l);

half sat(half3 c);

half mid(half cmin, half cmid, half cmax, half s);

half3 setsat(half3 c, half s);

#endif /* BBMetalShaderTypes_h */
