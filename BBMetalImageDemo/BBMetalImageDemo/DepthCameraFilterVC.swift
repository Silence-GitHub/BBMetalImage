//
//  DepthCameraFilterVC.swift
//  BBMetalImageDemo
//
//  Created by Kaibo Lu on 10/21/21.
//  Copyright © 2021 Kaibo Lu. All rights reserved.
//

import UIKit
import BBMetalImage

class DepthCameraFilterVC: UIViewController {

    private var camera: BBMetalCamera!
    private var effectFilter: BBMetalBaseFilter!
    private var mixFilter: DepthMixFilter!
    private var metalView: BBMetalView!
    private var videoWriter: BBMetalVideoWriter!
    private var filePath: String!
    
    private var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        if #available(iOS 13.0, *) {
            camera = BBMetalCamera(sessionPreset: .hd1920x1080, deviceType: .builtInDualWideCamera)
            camera.canGetDepthData = true
        }
        
        if camera == nil {
            let label = UILabel(frame: CGRect(x: 10, y: 100, width: view.bounds.width - 20, height: 100))
            label.textAlignment = .center
            label.text = "Depth camera is not supported"
            view.addSubview(label)
            return
        }
        
        let x: CGFloat = 10
        let width: CGFloat = view.bounds.width - 20
        metalView = BBMetalView(frame: CGRect(x: x, y: 100, width: width, height: view.bounds.height - 230))
        view.addSubview(metalView)
        
//        let tapMetalView = UITapGestureRecognizer(target: self, action: #selector(tapMetalView(_:)))
//        metalView.addGestureRecognizer(tapMetalView)
        
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
        videoWriter = BBMetalVideoWriter(url: url, frameSize: camera.textureSize)
        
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
    
    @objc private func clickFilterButton(_ button: UIButton) {
        button.isSelected.toggle()
        camera.removeAllConsumers()
        if button.isSelected {
            effectFilter = BBMetalLuminanceFilter()
            mixFilter = DepthMixFilter()
            
            camera.add(consumer: mixFilter)
                .add(consumer: metalView)
            
            camera.add(consumer: effectFilter)
                .add(consumer: mixFilter)
                .add(consumer: videoWriter)
            
            camera.add(depthConsumer: mixFilter)
            
        } else {
            camera.removeAllDepthConsumers()
            effectFilter.removeAllConsumers()
            mixFilter.removeAllConsumers()
            
            camera.add(consumer: metalView)
            camera.add(consumer: videoWriter)
        }
    }
    
    @objc private func clickRecordButton(_ button: UIButton) {
        button.isSelected.toggle()
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
