//
//  BBMetalImageConsumer.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/8/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

public protocol BBMetalImageConsumer: AnyObject {
    func add(source: BBMetalImageSource)
    func remove(source: BBMetalImageSource)
    func newTextureAvailable(_ texture: MTLTexture, from source: BBMetalImageSource)
}
