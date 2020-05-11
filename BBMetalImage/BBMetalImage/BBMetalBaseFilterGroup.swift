//
//  BBMetalBaseFilterGroup.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/11/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import Metal

/// A base filter group containing filters. Subclass this class. Do not create an instance using the class directly.
open class BBMetalBaseFilterGroup: BBMetalBaseFilter {
    public var initialFilters: [BBMetalBaseFilter]!
    public var terminalFilter: BBMetalBaseFilter!
    
    public override var consumers: [BBMetalImageConsumer] { return terminalFilter.consumers }
    
    public override var sources: [BBMetalWeakImageSource] { return initialFilters.first?.sources ?? [] }
    
    public override var outputTexture: MTLTexture? {
        return terminalFilter.outputTexture
    }
    
    public override var runSynchronously: Bool {
        get { return terminalFilter.runSynchronously }
        set { terminalFilter.runSynchronously = newValue }
    }
    
    @discardableResult
    public override func addCompletedHandler(_ handler: @escaping (MTLCommandBuffer) -> Void) -> String {
        return terminalFilter.addCompletedHandler(handler)
    }
    
    public override func removeCompletedHandler(for key: String) {
        terminalFilter.removeCompletedHandler(for: key)
    }
    
    public override func removeAllCompletedHandlers() {
        terminalFilter.removeAllCompletedHandlers()
    }
    
    // MARK: - BBMetalImageSource
    
    @discardableResult
    public override func add<T: BBMetalImageConsumer>(consumer: T) -> T {
        terminalFilter.add(consumer: consumer)
        return consumer
    }
    
    public override func add(consumer: BBMetalImageConsumer, at index: Int) {
        terminalFilter.add(consumer: consumer, at: index)
    }
    
    public override func remove(consumer: BBMetalImageConsumer) {
        terminalFilter.remove(consumer: consumer)
    }
    
    public override func removeAllConsumers() {
        terminalFilter.removeAllConsumers()
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
    
    public override func newTextureAvailable(_ texture: BBMetalTexture, from source: BBMetalImageSource) {
        for filter in initialFilters {
            filter.newTextureAvailable(texture, from: source)
        }
    }
}
