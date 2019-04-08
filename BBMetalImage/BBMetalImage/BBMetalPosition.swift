//
//  BBMetalPosition.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

/// Normalized position with coordinate values from 0.0 to 1.0
public struct BBMetalPosition {
    public var x: Float
    public var y: Float
    
    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
    
    public static let center = BBMetalPosition(x: 0.5, y: 0.5)
}
