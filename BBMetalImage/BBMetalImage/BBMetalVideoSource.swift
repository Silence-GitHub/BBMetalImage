//
//  BBMetalVideoSource.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/24/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import AVFoundation

public class BBMetalVideoSource {
    /// Image consumers
    public var consumers: [BBMetalImageConsumer] {
        lock.wait()
        let c = _consumers
        lock.signal()
        return c
    }
    private var _consumers: [BBMetalImageConsumer]
    
    private let url: URL
    private let lock: DispatchSemaphore
    
    private var asset: AVAsset!
    private var assetReader: AVAssetReader!
    private var videoOutput: AVAssetReaderTrackOutput!
    
    public var playWithVideoRate: Bool {
        get {
            lock.wait()
            let p = _playWithVideoRate
            lock.signal()
            return p
        }
        set {
            lock.wait()
            _playWithVideoRate = newValue
            lock.signal()
        }
    }
    private var _playWithVideoRate: Bool
    
    private var lastSampleFrameTime: CMTime!
    private var lastActualPlayTime: Double!
    
    #if !targetEnvironment(simulator)
    private var textureCache: CVMetalTextureCache!
    #endif
    
    public init?(url: URL) {
        _consumers = []
        self.url = url
        lock = DispatchSemaphore(value: 1)
        _playWithVideoRate = false
        
        #if !targetEnvironment(simulator)
        if CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, BBMetalDevice.sharedDevice, nil, &textureCache) != kCVReturnSuccess ||
            textureCache == nil {
            return nil
        }
        #endif
    }
    
    public func start() {
        lock.wait()
        let isReading = (assetReader != nil)
        lock.signal()
        if isReading {
            print("Should not call \(#function) while asset reader is reading")
            return
        }
        let asset = AVAsset(url: url)
        asset.loadValuesAsynchronously(forKeys: ["tracks"]) { [weak self] in
            guard let self = self else { return }
            if asset.statusOfValue(forKey: "tracks", error: nil) == .loaded,
                asset.tracks(withMediaType: .video).first != nil {
                DispatchQueue.global().async { [weak self] in
                    guard let self = self else { return }
                    self.lock.wait()
                    self.asset = asset
                    if self.prepareAssetReader() {
                        self.lock.signal()
                        self.processAsset()
                    } else {
                        self.reset()
                        self.lock.signal()
                    }
                }
            } else {
                self.safeReset()
            }
        }
    }
    
    public func cancel() {
        lock.wait()
        if let reader = assetReader,
            reader.status == .reading {
            reader.cancelReading()
            reset()
        }
        lock.signal()
    }
    
    private func safeReset() {
        lock.wait()
        reset()
        lock.signal()
    }
    
    private func reset() {
        asset = nil
        assetReader = nil
        videoOutput = nil
    }
    
    private func prepareAssetReader() -> Bool {
        guard let reader = try? AVAssetReader(asset: asset),
            let videoTrack = asset.tracks(withMediaType: .video).first else { return false }
        assetReader = reader
        videoOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA])
        videoOutput.alwaysCopiesSampleData = false
        if assetReader.canAdd(videoOutput) {
            assetReader.add(videoOutput)
            return true
        }
        return false
    }
    
    private func processAsset() {
        lock.wait()
        guard let reader = assetReader,
            reader.status == .unknown,
            reader.startReading() else {
            reset()
            lock.signal()
            return
        }
        lock.signal()
        
        lock.wait()
        while let reader = assetReader,
            reader.status == .reading,
            let sampleBuffer = videoOutput.copyNextSampleBuffer(),
            let texture = texture(with: sampleBuffer) {
                let sampleFrameTime = CMSampleBufferGetOutputPresentationTimeStamp(sampleBuffer)
                if _playWithVideoRate {
                    if let lastFrameTime = lastSampleFrameTime,
                        let lastPlayTime = lastActualPlayTime {
                        let detalFrameTime = CMTimeGetSeconds(CMTimeSubtract(sampleFrameTime, lastFrameTime))
                        let detalPlayTime = CACurrentMediaTime() - lastPlayTime
                        if detalFrameTime > detalPlayTime {
                            usleep(UInt32(1000000 * (detalFrameTime - detalPlayTime)))
                        }
                    }
                    lastSampleFrameTime = sampleFrameTime
                    lastActualPlayTime = CACurrentMediaTime()
                }
                let consumers = _consumers
                lock.signal()
                let output = BBMetalDefaultTexture(metalTexture: texture, sampleTime: sampleFrameTime)
                for consumer in consumers { consumer.newTextureAvailable(output, from: self) }
                lock.wait()
        }
        if assetReader != nil {
            reset()
        }
        lock.signal()
    }
    
    private func texture(with sampleBuffer: CMSampleBuffer) -> MTLTexture? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        
        #if !targetEnvironment(simulator)
        var cvMetalTextureOut: CVMetalTexture?
        let result = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                               textureCache,
                                                               imageBuffer,
                                                               nil,
                                                               .bgra8Unorm,
                                                               width,
                                                               height,
                                                               0,
                                                               &cvMetalTextureOut)
        if result == kCVReturnSuccess,
            let cvMetalTexture = cvMetalTextureOut,
            let texture = CVMetalTextureGetTexture(cvMetalTexture) {
            return texture
        }
        #endif
        return nil
    }
}

extension BBMetalVideoSource: BBMetalImageSource {
    @discardableResult
    public func add<T: BBMetalImageConsumer>(consumer: T) -> T {
        lock.wait()
        _consumers.append(consumer)
        lock.signal()
        consumer.add(source: self)
        return consumer
    }
    
    public func add(consumer: BBMetalImageConsumer, at index: Int) {
        lock.wait()
        _consumers.insert(consumer, at: index)
        lock.signal()
        consumer.add(source: self)
    }
    
    public func remove(consumer: BBMetalImageConsumer) {
        lock.wait()
        if let index = _consumers.firstIndex(where: { $0 === consumer }) {
            _consumers.remove(at: index)
            lock.signal()
            consumer.remove(source: self)
        } else {
            lock.signal()
        }
    }
    
    public func removeAllConsumers() {
        lock.wait()
        let consumers = _consumers
        _consumers.removeAll()
        lock.signal()
        for consumer in consumers {
            consumer.remove(source: self)
        }
    }
}
