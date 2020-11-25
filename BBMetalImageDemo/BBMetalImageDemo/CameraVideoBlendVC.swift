//
//  CameraVideoBlendVC.swift
//  BBMetalImageDemo
//
//  Created by Kaibo Lu on 11/24/20.
//  Copyright © 2020 Kaibo Lu. All rights reserved.
//

import UIKit
import BBMetalImage

class CameraVideoBlendVC: UIViewController {
    private var camera: BBMetalCamera!
    private var videoSource: BBMetalVideoSource!
    private var filter: BBMetalBaseFilter!
    private var metalView: BBMetalView!
    private var videoWriter: BBMetalVideoWriter!
    private var filePath: String!
    
    private var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        camera = BBMetalCamera(sessionPreset: .hd1920x1080)
        
        let url = Bundle.main.url(forResource: "test_video", withExtension: "mov")!
        videoSource = BBMetalVideoSource(url: url)
        videoSource.playWithVideoRate = true
        
        filter = BBMetalAlphaBlendFilter(mixturePercent: 0.5)
        
        let x: CGFloat = 10
        let width: CGFloat = view.bounds.width - 20
        metalView = BBMetalView(frame: CGRect(x: x, y: 100, width: width, height: view.bounds.height - 230))
        view.addSubview(metalView)
        
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
        let outputUrl = URL(fileURLWithPath: filePath)
        videoWriter = BBMetalVideoWriter(url: outputUrl, frameSize: BBMetalIntSize(width: 1080, height: 1920))
        
        camera.audioConsumer = videoWriter
        
        camera.add(consumer: metalView)
        camera.add(consumer: videoWriter)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        camera.start()
        videoSource.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        camera.stop()
        videoSource.cancel()
    }
    
    @objc private func clickFilterButton(_ button: UIButton) {
        button.isSelected = !button.isSelected
        camera.removeAllConsumers()
        videoSource.removeAllConsumers()
        filter.removeAllConsumers()
        if button.isSelected {
            camera.add(consumer: filter).add(consumer: metalView)
            videoSource.add(consumer: filter).add(consumer: videoWriter)
        } else {
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
}
