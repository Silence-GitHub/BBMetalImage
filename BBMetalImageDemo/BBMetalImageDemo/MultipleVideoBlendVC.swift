//
//  MultipleVideoBlendVC.swift
//  BBMetalImageDemo
//
//  Created by Kaibo Lu on 7/25/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit
import AVFoundation
import BBMetalImage

class MultipleVideoBlendVC: UIViewController {
    private var videoSource: MultipleVideoSource!
    private var videoWriter: BBMetalVideoWriter!
    private var metalView: BBMetalView!
    
    private var filePath: String!
    
    private var filterButton: UIButton!
    private var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .gray
        
        filePath = NSTemporaryDirectory() + "test.mp4"
        
        metalView = BBMetalView(frame: CGRect(x: 10, y: 100, width: view.bounds.width - 20, height: view.bounds.height - 200))
        view.addSubview(metalView)
        
        filterButton = UIButton(frame: CGRect(x: 10, y: view.bounds.height - 90, width: view.bounds.width - 20, height: 30))
        filterButton.backgroundColor = .blue
        filterButton.setTitle("Start", for: .normal)
        filterButton.addTarget(self, action: #selector(clickFilterButton(_:)), for: .touchUpInside)
        self.view.addSubview(filterButton)
        
        playButton = UIButton(frame: CGRect(x: 10, y: view.bounds.height - 60, width: view.bounds.width - 20, height: 30))
        playButton.backgroundColor = .red
        playButton.setTitle("Play", for: .normal)
        playButton.addTarget(self, action: #selector(clickPlayButton(_:)), for: .touchUpInside)
        self.view.addSubview(playButton)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let source = videoSource { source.cancel() }
    }
    
    @objc private func clickFilterButton(_ button: UIButton) {
        filterButton.isHidden = true
        playButton.isHidden = true
        
        let url = Bundle.main.url(forResource: "test_video", withExtension: "mov")!
        let url2 = Bundle.main.url(forResource: "test_video_rotate_right", withExtension: "mov")!
        videoSource = MultipleVideoSource(urls: [url, url2])
        
        let blendFilter = BBMetalAlphaBlendFilter(mixturePercent: 0.2)
        
        let outputUrl = URL(fileURLWithPath: filePath)
        try? FileManager.default.removeItem(at: outputUrl)
        videoWriter = BBMetalVideoWriter(url: outputUrl, frameSize: BBMetalIntSize(width: 1080, height: 1920))
        videoWriter.hasAudioTrack = false
        
        videoSource.videoSource(at: 0)?
            .add(consumer: blendFilter)
            .add(consumer: metalView)
        videoSource.videoSource(at: 1)?
            .add(consumer: blendFilter)
            .add(consumer: videoWriter)
        
        videoWriter.start ()
        videoSource.start(progress: { (frameTime) in
            // print(frameTime)
        }) { [weak self] (_) in
            guard let self = self else { return }
            self.videoWriter.finish {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.filterButton.isHidden = false
                    self.playButton.isHidden = false
                    self.videoWriter = nil
                    self.videoSource = nil
                }
            }
        }
    }
    
    @objc private func clickPlayButton(_ button: UIButton) {
        if FileManager.default.fileExists(atPath: filePath) {
            navigationController?.pushViewController(VideoPlayerVC(url: URL(fileURLWithPath: filePath)), animated: true)
        }
    }
}
