//
//  VideoFilterVC2.swift
//  BBMetalImageDemo
//
//  Created by Kaibo Lu on 5/7/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit
import AVFoundation
import BBMetalImage

class VideoFilterVC2: UIViewController {
    private var sourceURL: URL!
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    
    private var videoSource: BBMetalVideoSource!
    private var videoWriter: BBMetalVideoWriter!
    
    private var filterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        sourceURL = Bundle.main.url(forResource: "test_video_2", withExtension: "mov")!
        
        player = AVPlayer(url: sourceURL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 10, y: 100, width: view.bounds.width - 20, height: view.bounds.height - 200)
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        
        let button = UIButton(frame: CGRect(x: 10, y: view.bounds.height - 90, width: view.bounds.width - 20, height: 30))
        button.backgroundColor = .blue
        button.setTitle("Add filter", for: .normal)
        button.setTitle("Remove filter", for: .selected)
        button.addTarget(self, action: #selector(clickFilterButton(_:)), for: .touchUpInside)
        self.view.addSubview(button)
        filterButton = button
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [])
        try? AVAudioSession.sharedInstance().setActive(true, options: [])
        player.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let source = videoSource { source.cancel() }
    }
    
    @objc private func clickFilterButton(_ button: UIButton) {
        player.pause()
        
        button.isSelected = !button.isSelected
        if button.isSelected {
            filterButton.isHidden = true
            
            let filePath = NSTemporaryDirectory() + "test.mp4"
            let outputUrl = URL(fileURLWithPath: filePath)
            try? FileManager.default.removeItem(at: outputUrl)
            videoWriter = BBMetalVideoWriter(url: outputUrl, frameSize: BBMetalIntSize(width: 1080, height: 1920))
            
            videoSource = BBMetalVideoSource(url: sourceURL)
            videoSource.audioConsumer = videoWriter
            
            let filter = BBMetalColorInversionFilter()
            videoSource.add(consumer: filter).add(consumer: videoWriter)
            
            videoWriter.start()
            
            videoSource.start(progress: { (frameTime) in
                // print(frameTime)
            }) { [weak self] (_) in
                guard let self = self else { return }
                self.videoWriter.finish {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.filterButton.isHidden = false
                        self.player = AVPlayer(url: outputUrl)
                        self.playerLayer.player = self.player
                        self.player.play()
                        self.videoWriter = nil
                        self.videoSource = nil
                    }
                }
            }
        } else {
            player = AVPlayer(url: sourceURL)
            playerLayer.player = player
            player.play()
        }
    }
}
