//
//  BBMetalImageSource.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/8/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

/// Defines image source behaviors
public protocol BBMetalImageSource: AnyObject {
    /// Adds an image consumer to consume the output texture
    ///
    /// - Parameter consumer: image consumer object to add
    /// - Returns: image consumer object to add
    func add<T: BBMetalImageConsumer>(consumer: T) -> T
    
    /// Adds an image consumer at the specific index
    ///
    /// - Parameters:
    ///   - consumer: image consumer object to add
    ///   - index: index for the image consumer object
    func add(consumer: BBMetalImageConsumer, at index: Int)
    
    /// Removes the image consumer
    ///
    /// - Parameter consumer: image consumer object to remove
    func remove(consumer: BBMetalImageConsumer)
    
    /// Removes all image consumers
    func removeAllConsumers()
}
