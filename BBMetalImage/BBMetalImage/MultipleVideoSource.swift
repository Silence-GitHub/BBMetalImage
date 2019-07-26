//
//  MultipleVideoSource.swift
//  BBMetalImageDemo
//
//  Created by Kaibo Lu on 7/25/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import AVFoundation

fileprivate struct BBMetalAssetItem {
    fileprivate var asset: AVAsset?
    fileprivate var assetReader: AVAssetReader?
    fileprivate var videoOutput: AVAssetReaderTrackOutput?
}

public class MultipleVideoSource {
    
    private class VideoSource: BBMetalImageSource {
        let resizeFilter = BBMetalResizeFilter(size: BBMetalSize(width: 1, height: 1))
        
        init() { resizeFilter.add(source: self) }
        
        @discardableResult
        func add<T: BBMetalImageConsumer>(consumer: T) -> T { return consumer }
        func add(consumer: BBMetalImageConsumer, at index: Int) {}
        func remove(consumer: BBMetalImageConsumer) {}
        func removeAllConsumers() {}
    }
    
    /// Image consumers
    public var consumers: [BBMetalImageConsumer] {
        return videoSources.first!.resizeFilter.consumers
    }
    
    private let urls: [URL]
    private let videoSources: [VideoSource]
    private let lock: DispatchSemaphore
    
    private var assets: [BBMetalAssetItem]
    
    private var textureSize: BBMetalIntSize
    
    private var textureCache: CVMetalTextureCache!
    
    public init?(urls: [URL]) {
        if urls.isEmpty { return nil }
        
        self.urls = urls
        var sources: [VideoSource] = []
        for _ in urls {
            sources.append(VideoSource())
        }
        videoSources = sources
        lock = DispatchSemaphore(value: 1)
        
        assets = []
        textureSize = BBMetalIntSize(width: 0, height: 0)
        
        #if !targetEnvironment(simulator)
        if CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, BBMetalDevice.sharedDevice, nil, &textureCache) != kCVReturnSuccess ||
            textureCache == nil {
            return nil
        }
        #endif
    }
    
    public func videoSource(at index: Int) -> BBMetalImageSource? {
        return index < videoSources.count && index >= 0 ? videoSources[index].resizeFilter : nil
    }
    
    public func start(progress: BBMetalVideoSourceProgress? = nil, completion: BBMetalVideoSourceCompletion? = nil) {
        lock.wait()
        let isReading = assets.firstIndex { $0.assetReader != nil } != nil
        lock.signal()
        if isReading {
            print("Should not call \(#function) while asset reader is reading")
            return
        }
        var newAssets: [BBMetalAssetItem] = .init(repeating: BBMetalAssetItem(), count: urls.count)
        var stop = false
        for i in 0..<urls.count {
            if stop { break }
            let url = urls[i]
            let asset = AVAsset(url: url)
            let index = i
            asset.loadValuesAsynchronously(forKeys: ["tracks"]) { [weak self] in
                guard let self = self, !stop else { return }
                if asset.statusOfValue(forKey: "tracks", error: nil) == .loaded,
                    asset.tracks(withMediaType: .video).first != nil {
                    DispatchQueue.global().async { [weak self] in
                        guard let self = self, !stop else { return }
                        newAssets[index].asset = asset
                        if let result = self.prepareAssetReader(for: asset) {
                            newAssets[index].assetReader = result.0
                            newAssets[index].videoOutput = result.1
                            if newAssets.firstIndex(where: { $0.assetReader == nil }) == nil {
                                self.lock.wait()
                                self.assets = newAssets
                                self.lock.signal()
                                self.processAsset(progress: progress, completion: completion)
                            }
                        } else {
                            stop = true
                            self.safeReset()
                        }
                    }
                } else {
                    stop = true
                    self.safeReset()
                }
            }
        }
    }
    
    public func cancel() {
        lock.wait()
        for item in assets {
            if let reader = item.assetReader,
                reader.status == .reading {
                reader.cancelReading()
            }
        }
        if !assets.isEmpty { reset() }
        lock.signal()
    }
    
    private func safeReset() {
        lock.wait()
        reset()
        lock.signal()
    }
    
    private func reset() {
        assets.removeAll()
        textureSize = BBMetalIntSize(width: 0, height: 0)
    }
    
    private func prepareAssetReader(for asset: AVAsset) -> (AVAssetReader, AVAssetReaderTrackOutput)? {
        guard let reader = try? AVAssetReader(asset: asset),
            let videoTrack = asset.tracks(withMediaType: .video).first else { return nil }
        let videoOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA])
        videoOutput.alwaysCopiesSampleData = false
        if !reader.canAdd(videoOutput) { return nil }
        reader.add(videoOutput)
        return (reader, videoOutput)
    }
    
    private func processAsset(progress: BBMetalVideoSourceProgress?, completion: BBMetalVideoSourceCompletion?) {
        lock.wait()
        for item in assets {
            guard let reader = item.assetReader,
                reader.status == .unknown,
                reader.startReading() else {
                reset()
                lock.signal()
                return
            }
        }
        lock.signal()
        
        // Read and process video buffer
        lock.wait()
        var stop = false
        while !assets.isEmpty {
            var outputs: [BBMetalTexture] = []
            for i in 0..<assets.count {
                let item = assets[i]
                guard let reader = item.assetReader,
                    reader.status == .reading,
                    let sampleBuffer = item.videoOutput?.copyNextSampleBuffer(),
                    let texture = texture(with: sampleBuffer) else {
                    stop = true
                    break
                }
                if textureSize.width == 0 || textureSize.height == 0 {
                    textureSize = BBMetalIntSize(width: texture.metalTexture.width, height: texture.metalTexture.height)
                } else if textureSize.width != texture.metalTexture.width || textureSize.height != texture.metalTexture.height {
                    let filter = videoSources[i].resizeFilter
                    filter.size = BBMetalSize(width: Float(textureSize.width) / Float(texture.metalTexture.width),
                                              height: Float(textureSize.height) / Float(texture.metalTexture.height))
                }
                let sampleFrameTime = CMSampleBufferGetOutputPresentationTimeStamp(sampleBuffer)
                outputs.append(BBMetalDefaultTexture(metalTexture: texture.metalTexture,
                                                     sampleTime: sampleFrameTime,
                                                     cvMetalTexture: texture.cvMetalTexture))
            }
            if stop { break }
            lock.signal()
            
            for i in 0..<outputs.count {
                videoSources[i].resizeFilter.newTextureAvailable(outputs[i], from: videoSources[i])
            }
            progress?(outputs.first!.sampleTime!)
            
            lock.wait()
        }
        var finish = false
        if !assets.isEmpty {
            finish = true
            reset()
        }
        lock.signal()
        
        completion?(finish)
    }
    
    private func texture(with sampleBuffer: CMSampleBuffer) -> BBMetalVideoTextureItem? {
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
            return BBMetalVideoTextureItem(metalTexture: texture, cvMetalTexture: cvMetalTexture)
        }
        #endif
        return nil
    }
}
