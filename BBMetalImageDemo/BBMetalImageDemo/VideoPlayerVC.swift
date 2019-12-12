//
//  VideoPlayerVC.swift
//  BBMetalImageDemo
//
//  Created by Kaibo Lu on 5/1/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerVC: UIViewController {
    private let url: URL
    private let videoGravity: AVLayerVideoGravity
    
    private var player: AVPlayer!
    
    init(url: URL, videoGravity: AVLayerVideoGravity = .resizeAspectFill) {
        self.url = url
        self.videoGravity = videoGravity
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        player = AVPlayer(url: url)
        let layer = AVPlayerLayer(player: player)
        layer.frame = CGRect(x: 10, y: 100, width: view.bounds.width - 20, height: view.bounds.height - 200)
        layer.videoGravity = videoGravity
        view.layer.addSublayer(layer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [])
        try? AVAudioSession.sharedInstance().setActive(true, options: [])
        player.play()
    }
}
