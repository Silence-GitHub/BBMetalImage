//
//  MultipleImageBlendVC.swift
//  BBMetalImageDemo
//
//  Created by Kaibo Lu on 7/29/20.
//  Copyright © 2020 Kaibo Lu. All rights reserved.
//

import UIKit
import AVFoundation
import BBMetalImage

class MultipleImageBlendVC: UIViewController {
    private var camera: BBMetalCamera!
    private var metalView: BBMetalView!
    private var imageSource: BBMetalMultipleImageSource!
    private var videoWriter: BBMetalVideoWriter!
    private var filePath: String!
    
    private var imageSourceIndex: Int = 0
    private var frameCount: Int = 0
    
    private var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        let x: CGFloat = 10
        let width: CGFloat = view.bounds.width - 20
        metalView = BBMetalView(frame: CGRect(x: x, y: 100, width: width, height: view.bounds.height - 230))
        view.addSubview(metalView)
        
        let tapMetalView = UITapGestureRecognizer(target: self, action: #selector(tapMetalView(_:)))
        metalView.addGestureRecognizer(tapMetalView)
        
        var y: CGFloat = metalView.frame.maxY + 10
        var i = 0
        func generateButton(title: String, selectedTitle: String? = nil) -> UIButton {
            let button = UIButton(frame: CGRect(x: x, y: y, width: width, height: 30))
            button.backgroundColor = (i % 2 == 0 ? .blue : .red)
            button.setTitle(title, for: .normal)
            button.setTitle(selectedTitle, for: .selected)
            self.view.addSubview(button)
            i += 1
            y += button.frame.height
            return button
        }
        
        let filterButton = generateButton(title: "Add filter", selectedTitle: "Remove filter")
        filterButton.addTarget(self, action: #selector(clickFilterButton(_:)), for: .touchUpInside)
        
        let recordButton = generateButton(title: "Start recording", selectedTitle: "Finish recording")
        recordButton.addTarget(self, action: #selector(clickRecordButton(_:)), for: .touchUpInside)
        
        playButton = generateButton(title: "Play")
        playButton.addTarget(self, action: #selector(clickPlayButton(_:)), for: .touchUpInside)
        
        filePath = NSTemporaryDirectory() + "test.mp4"
        let url = URL(fileURLWithPath: filePath)
        videoWriter = BBMetalVideoWriter(url: url, frameSize: BBMetalIntSize(width: 1080, height: 1920))
        
        camera = BBMetalCamera(sessionPreset: .hd1920x1080)
        camera.audioConsumer = videoWriter
        camera.add(consumer: metalView)
        camera.add(consumer: videoWriter)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        try? AVAudioSession.sharedInstance().setCategory(.record, mode: .videoRecording, options: [])
        try? AVAudioSession.sharedInstance().setActive(true, options: [])
        camera.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        camera.stop()
    }
    
    @objc private func tapMetalView(_ tap: UITapGestureRecognizer) {
        camera.switchCameraPosition()
    }
    
    @objc private func clickFilterButton(_ button: UIButton) {
        button.isSelected = !button.isSelected
        camera.removeAllConsumers()
        if button.isSelected {
            let images: [UIImage] = [
                topBlendImage(withAlpha: 0.2),
                topBlendImage(withAlpha: 0.4),
                topBlendImage(withAlpha: 0.6),
                topBlendImage(withAlpha: 0.8),
                topBlendImage(withAlpha: 1.0),
            ]
            imageSource = BBMetalMultipleImageSource(images: images)
            let filter = BBMetalNormalBlendFilter()
            camera.add(consumer: filter).add(consumer: metalView)
            imageSource.add(consumer: filter).add(consumer: videoWriter)
            camera.willTransmitTexture = { [weak self] _, _ in
                guard let self = self else { return }
                self.frameCount += 1
                if self.frameCount == 30 {
                    self.frameCount = 0
                    self.imageSourceIndex = (self.imageSourceIndex + 1) % self.imageSource.sourceCount
                }
                self.imageSource.transmitTexture(at: self.imageSourceIndex)
            }
        } else {
            imageSource = nil
            camera.willTransmitTexture = nil
            camera.add(consumer: metalView)
            camera.add(consumer: videoWriter)
        }
    }
    
    @objc private func clickRecordButton(_ button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            playButton.isHidden = true
            try? FileManager.default.removeItem(at: videoWriter.url)
            videoWriter.start()
        } else {
            videoWriter.finish { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.playButton.isHidden = false
                }
            }
        }
    }
    
    @objc private func clickPlayButton(_ button: UIButton) {
        if FileManager.default.fileExists(atPath: filePath) {
            navigationController?.pushViewController(VideoPlayerVC(url: videoWriter.url), animated: true)
        }
    }
    
    private func topBlendImage(withAlpha alpha: Float) -> UIImage {
        let image = UIImage(named: "multicolour_flowers.jpg")!
        if alpha == 1 { return image }
        return BBMetalRGBAFilter(alpha: alpha).filteredImage(with: image)!
    }
}
