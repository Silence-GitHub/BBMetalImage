//
//  BBMetalVideoWriter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/30/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import AVFoundation

public class BBMetalVideoWriter {
    private let url: URL
    private let frameSize: BBMetalIntSize
    private let fileType: AVFileType
    private let outputSettings: [String : Any]
    
    private var writer: AVAssetWriter!
    private var videoInput: AVAssetWriterInput!
    private var videoPixelBufferInput: AVAssetWriterInputPixelBufferAdaptor!
    private var videoPixelBuffer: CVPixelBuffer!
    
    private let lock: DispatchSemaphore
    
    public init(url: URL,
                frameSize: BBMetalIntSize,
                fileType: AVFileType = .mp4,
                outputSettings: [String : Any] = [AVVideoCodecKey : AVVideoCodecH264]) {
        
        self.url = url
        self.frameSize = frameSize
        self.fileType = fileType
        self.outputSettings = outputSettings
        lock = DispatchSemaphore(value: 1)
    }
    
    public func start() {
        lock.wait()
        defer { lock.signal() }
        if writer == nil {
            if !prepareAssetWriter() {
                reset()
                return
            }
        } else {
            print("Should not call \(#function) before last writing operation is finished")
            return
        }
        writer.startWriting()
    }
    
    public func finish(completion: (() -> Void)?) {
        lock.wait()
        defer { lock.signal() }
        if let videoInput = self.videoInput,
            let writer = self.writer,
            writer.status == .writing {
            videoInput.markAsFinished()
            writer.finishWriting { [weak self] in
                guard let self = self else { return }
                self.lock.wait()
                self.reset()
                self.lock.signal()
                completion?()
            }
        } else {
            print("Should not call \(#function) while video writer is not writing")
        }
    }
    
    public func cancel() {
        lock.wait()
        defer { lock.signal() }
        if let videoInput = self.videoInput,
            let writer = self.writer,
            writer.status == .writing {
            videoInput.markAsFinished()
            writer.cancelWriting()
            reset()
        } else {
            print("Should not call \(#function) while video writer is not writing")
        }
    }
    
    private func prepareAssetWriter() -> Bool {
        writer = try? AVAssetWriter(url: url, fileType: fileType)
        if writer == nil {
            print("Can not create asset writer")
            return false
        }
        
        var settings = outputSettings
        settings[AVVideoWidthKey] = frameSize.width
        settings[AVVideoHeightKey] = frameSize.height
        videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: settings)
        if !writer.canAdd(videoInput) {
            print("Asset writer can not add input")
            return false
        }
        writer.add(videoInput)
        
        let attributes: [String : Any] = [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA,
                                          kCVPixelBufferWidthKey as String : frameSize.width,
                                          kCVPixelBufferHeightKey as String : frameSize.height]
        videoPixelBufferInput = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoInput, sourcePixelBufferAttributes: attributes)
        return true
    }
    
    private func reset() {
        writer = nil
        videoInput = nil
        videoPixelBufferInput = nil
        videoPixelBuffer = nil
    }
}

extension BBMetalVideoWriter: BBMetalImageConsumer {
    public func add(source: BBMetalImageSource) {}
    public func remove(source: BBMetalImageSource) {}
    
    public func newTextureAvailable(_ texture: BBMetalTexture, from source: BBMetalImageSource) {
        lock.wait()
        defer { lock.signal() }
        
        // Check nil
        guard let sampleTime = texture.sampleTime,
            let writer = self.writer,
            let videoInput = self.videoInput,
            let videoPixelBufferInput = self.videoPixelBufferInput else { return }
        
        // The property `pixelBufferPool` is NULL before the first call to startSessionAtTime: on the associated AVAssetWriter object
        if videoPixelBufferInput.pixelBufferPool == nil {
            writer.startSession(atSourceTime: sampleTime)
        }
        
        // Check status
        guard videoInput.isReadyForMoreMediaData,
            writer.status == .writing else { return }
        
        // Copy data from metal texture to pixel buffer
        guard let pool = videoPixelBufferInput.pixelBufferPool,
            CVPixelBufferPoolCreatePixelBuffer(nil, pool, &videoPixelBuffer) == kCVReturnSuccess,
            videoPixelBuffer != nil,
            CVPixelBufferLockBaseAddress(videoPixelBuffer, []) == kCVReturnSuccess,
            let baseAddress = CVPixelBufferGetBaseAddress(videoPixelBuffer) else { return }
        
        let bytesPerRow = CVPixelBufferGetBytesPerRow(videoPixelBuffer)
        let region = MTLRegionMake2D(0, 0, texture.metalTexture.width, texture.metalTexture.height)
        texture.metalTexture.getBytes(baseAddress, bytesPerRow: bytesPerRow, from: region, mipmapLevel: 0)

        videoPixelBufferInput.append(videoPixelBuffer, withPresentationTime: sampleTime)
        
        CVPixelBufferUnlockBaseAddress(videoPixelBuffer, [])
    }
}
