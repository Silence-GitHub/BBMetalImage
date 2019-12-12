//
//  RecordUIVC.swift
//  BBMetalImageDemo
//
//  Created by Kaibo Lu on 12/11/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit
import AVFoundation
import BBMetalImage

class RecordUIVC: UIViewController {
    private var animationView: UIView!
    private var icon: UILabel!
    private var playButton: UIButton!
    
    private var displayLink: CADisplayLink!
    private var stepX: CGFloat = 1
    private var stepY: CGFloat = 1
    private var stepCount: Int64 = 0
    
    private var uiSource: BBMetalUISource!
    private var videoWriter: BBMetalVideoWriter!
    private var filePath: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        animationView = UIView(frame: CGRect(x: 10, y: 100, width: view.bounds.width - 20, height: 100))
        animationView.backgroundColor = .blue
        animationView.contentScaleFactor = UIScreen.main.scale
        view.addSubview(animationView)
        
        icon = UILabel(frame: CGRect(x: 0, y: 25, width: 50, height: 50))
        icon.backgroundColor = .red
        icon.font = .systemFont(ofSize: 20)
        icon.textAlignment = .center
        icon.text = "ABC"
        animationView.addSubview(icon)
        
        var frame = animationView.frame
        frame.origin.y = frame.maxY + 10
        frame.size.height += 20
        let metalView = BBMetalView(frame: frame)
        metalView.bb_textureContentMode = .aspectRatioFit
        view.addSubview(metalView)
        
        uiSource = BBMetalUISource(view: animationView)
        let filter = BBMetalHueFilter(hue: 45)
        uiSource.add(consumer: filter)
            .add(consumer: metalView)
        
        filePath = NSTemporaryDirectory() + "test.mp4"
        let outputUrl = URL(fileURLWithPath: filePath)
        let frameSize = uiSource.renderPixelSize!
        videoWriter = BBMetalVideoWriter(url: outputUrl, frameSize: BBMetalIntSize(width: Int(frameSize.width), height: Int(frameSize.height)))
        filter.add(consumer: videoWriter)
        
        frame.origin.y = frame.maxY + 10
        frame.size.height = 50
        let recordButton = UIButton(frame: frame)
        recordButton.backgroundColor = .blue
        recordButton.setTitle("Start recording", for: .normal)
        recordButton.setTitle("Finish recording", for: .selected)
        recordButton.addTarget(self, action: #selector(clickRecordButton(_:)), for: .touchUpInside)
        view.addSubview(recordButton)
        
        frame.origin.y = frame.maxY + 10
        playButton = UIButton(frame: frame)
        playButton.backgroundColor = .red
        playButton.setTitle("Play", for: .normal)
        playButton.addTarget(self, action: #selector(clickPlayButton(_:)), for: .touchUpInside)
        view.addSubview(playButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if displayLink != nil {
            displayLink.invalidate()
            displayLink = nil
        }
    }
    
    @objc private func refreshDisplayLink(_ link: CADisplayLink) {
        icon.center.x += stepX
        icon.center.y += stepY
        if icon.frame.maxX >= animationView.bounds.width {
            stepX = -1
        } else if icon.frame.minX <= 0 {
            stepX = 1
        }
        if icon.frame.maxY >= animationView.bounds.height {
            stepY = -1
        } else if icon.frame.minY <= 0 {
            stepY = 1
        }
        stepCount += 1
        uiSource.transmitTexture(with: CMTime(value: stepCount, timescale: 60))
    }
    
    @objc private func clickRecordButton(_ button: UIButton) {
        button.isSelected = !button.isSelected
        
        if displayLink == nil {
            displayLink = CADisplayLink(target: self, selector: #selector(refreshDisplayLink(_:)))
            displayLink.add(to: .main, forMode: .common)
        }
        if button.isSelected {
            try? FileManager.default.removeItem(at: videoWriter.url)
            videoWriter.start()
            
            stepCount = 0
            playButton.isHidden = true
            displayLink.isPaused = false
        } else {
            displayLink.isPaused = true
            
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
            navigationController?.pushViewController(VideoPlayerVC(url: videoWriter.url, videoGravity: .resizeAspect), animated: true)
        }
    }
}
