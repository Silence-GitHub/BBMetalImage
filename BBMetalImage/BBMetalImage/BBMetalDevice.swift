//
//  BBMetalDevice.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/1/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal
import CoreGraphics

/// A singleton class containing shared resources
public class BBMetalDevice {
    public static let shared: BBMetalDevice = BBMetalDevice()
    public static var sharedDevice: MTLDevice { return shared.device }
    public static var sharedCommandQueue: MTLCommandQueue { return shared.commandQueue }
    public static var sharedColorSpace: CGColorSpace { return shared.colorSpace }
    
    public let device: MTLDevice
    public let commandQueue: MTLCommandQueue
    public let colorSpace: CGColorSpace
    
    private init() {
        device = MTLCreateSystemDefaultDevice()!
        commandQueue = device.makeCommandQueue()!
        colorSpace = CGColorSpaceCreateDeviceRGB()
    }
}
