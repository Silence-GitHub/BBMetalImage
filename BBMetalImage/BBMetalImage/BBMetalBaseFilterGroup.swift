//
//  BBMetalBaseFilterGroup.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/11/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

public class BBMetalBaseFilterGroup: BBMetalBaseFilter {
    public var initialFilters: [BBMetalBaseFilter]!
    public var terminalFilter: BBMetalBaseFilter!
    
    public override var outputTexture: MTLTexture? {
        return terminalFilter.outputTexture
    }
    
    // MARK: - BBMetalImageSource
    
    @discardableResult
    public override func add<T: BBMetalImageConsumer>(consumer: T) -> T {
        terminalFilter.add(consumer: consumer)
        consumer.add(source: terminalFilter)
        return consumer
    }
    
    public override func add(consumer: BBMetalImageConsumer, at index: Int) {
        terminalFilter.add(consumer: consumer, at: index)
        consumer.add(source: terminalFilter)
    }
    
    public override func remove(consumer: BBMetalImageConsumer) {
        terminalFilter.remove(consumer: consumer)
        consumer.remove(source: terminalFilter)
    }
    
    // MARK: - BBMetalImageConsumer
    
    public override func add(source: BBMetalImageSource) {
        for filter in initialFilters {
            filter.add(source: source)
        }
    }
    
    public override func remove(source: BBMetalImageSource) {
        for filter in initialFilters {
            filter.remove(source: source)
        }
    }
    
    public override func newTextureAvailable(_ texture: MTLTexture, from source: BBMetalImageSource) {
        for filter in initialFilters {
            filter.newTextureAvailable(texture, from: source)
        }
    }
}
