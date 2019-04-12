//
//  BBMetalImageSource.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/8/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

public protocol BBMetalImageSource: AnyObject {
    func add<T: BBMetalImageConsumer>(consumer: T) -> T
    func add(consumer: BBMetalImageConsumer, at index: Int)
    func remove(consumer: BBMetalImageConsumer)
    func removeAllConsumers()
}
