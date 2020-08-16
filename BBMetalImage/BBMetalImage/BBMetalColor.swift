//
//  BBMetalColor.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import simd

/// RGBA with normalized color channel value form 0.0 to 1.0
public struct BBMetalColor {
    public var red: Float
    public var green: Float
    public var blue: Float
    public var alpha: Float
    
    public init(red: Float, green: Float, blue: Float, alpha: Float = 1) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    public static let black = BBMetalColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    public static let white = BBMetalColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    public static let red = BBMetalColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    public static let green = BBMetalColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
    public static let blue = BBMetalColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
    public static let transparent = BBMetalColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
}

/// RGB with normalized color channel value form 0.0 to 1.0
public typealias BBMetalOpaqueColor = SIMD3<Float>

extension BBMetalOpaqueColor {
    public var red: Float {
        get { return x }
        set { x = newValue }
    }
    
    public var green: Float {
        get { return y }
        set { y = newValue }
    }
    
    public var blue: Float {
        get { return z }
        set { z = newValue }
    }
    
    public init(red: Float, green: Float, blue: Float) {
        self.init(x: red, y: green, z: blue)
    }
    
    public static let black = BBMetalOpaqueColor(red: 0.0, green: 0.0, blue: 0.0)
    public static let white = BBMetalOpaqueColor(red: 1.0, green: 1.0, blue: 1.0)
    public static let red = BBMetalOpaqueColor(red: 1.0, green: 0.0, blue: 0.0)
    public static let green = BBMetalOpaqueColor(red: 0.0, green: 1.0, blue: 0.0)
    public static let blue = BBMetalOpaqueColor(red: 0.0, green: 0.0, blue: 1.0)
}
