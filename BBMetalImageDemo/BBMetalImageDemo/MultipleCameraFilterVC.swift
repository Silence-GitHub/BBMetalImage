//
//  MultipleCameraFilterVC.swift
//  BBMetalImageDemo
//
//  Created by Kaibo Lu on 10/5/21.
//  Copyright © 2021 Kaibo Lu. All rights reserved.
//

import UIKit
import BBMetalImage

class MultipleCameraFilterVC: UIViewController {

    private var fullScreenBack: Bool = true
    private var needFilter: Bool = false
    
    @available(iOS 13.0, *)
    private var camera: BBMetalMultipleCamera! {
        _camera as? BBMetalMultipleCamera
    }
    private var _camera: AnyObject!
    
    private var vibranceFilter: BBMetalBaseFilter!
    private var contrastFilter: BBMetalBaseFilter!
    private var pipFilter: PiPFilter!
    private var metalView: BBMetalView!
    private var videoWriter: BBMetalVideoWriter!
    private var filePath: String!
    
    private var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .gray
        
        if #available(iOS 13.0, *) {
            _camera = BBMetalMultipleCamera()
        }
        
        if _camera == nil {
            let label = UILabel(frame: CGRect(x: 10, y: 100, width: view.bounds.width - 20, height: 100))
            label.textAlignment = .center
            label.text = "Multiple camera is not supported"
            view.addSubview(label)
            return
        }
        
        guard #available(iOS 13.0, *) else { return }
        
        vibranceFilter = BBMetalVibranceFilter(vibrance: 1)
        contrastFilter = BBMetalContrastFilter(contrast: 1.5)
        pipFilter = PiPFilter(pipFrame: .init(x: 0.6, y: 0.6, z: 0.3, w: 0.3))
        
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
        
        pipFilter.add(consumer: metalView)
        pipFilter.add(consumer: videoWriter)
        
        updateFilterChain()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        try? AVAudioSession.sharedInstance().setCategory(.record, mode: .videoRecording, options: [])
        try? AVAudioSession.sharedInstance().setActive(true, options: [])
        
        if _camera == nil { return }
        
        if #available(iOS 13.0, *) {
            camera.backCamera.start()
            camera.frontCamera.start()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if _camera == nil { return }
        
        if #available(iOS 13.0, *) {
            camera.backCamera.stop()
            camera.frontCamera.stop()
        }
    }
    
    @available(iOS 13.0, *)
    private func updateFilterChain() {
        camera.frontCamera.removeAllConsumers()
        camera.backCamera.removeAllConsumers()
        vibranceFilter.removeAllConsumers()
        contrastFilter.removeAllConsumers()
        
        if fullScreenBack {
            if needFilter {
                camera.backCamera.add(consumer: vibranceFilter)
                    .add(consumer: pipFilter)
                camera.frontCamera.add(consumer: contrastFilter)
                    .add(consumer: pipFilter)
            } else {
                camera.backCamera.add(consumer: pipFilter)
                camera.frontCamera.add(consumer: pipFilter)
            }
        } else {
            if needFilter {
                camera.frontCamera.add(consumer: contrastFilter)
                    .add(consumer: pipFilter)
                camera.backCamera.add(consumer: vibranceFilter)
                    .add(consumer: pipFilter)
            } else {
                camera.frontCamera.add(consumer: pipFilter)
                camera.backCamera.add(consumer: pipFilter)
            }
        }
    }
    
    @available(iOS 13.0, *)
    @objc private func tapMetalView(_ tap: UITapGestureRecognizer) {
        fullScreenBack.toggle()
        updateFilterChain()
    }
    
    @available(iOS 13.0, *)
    @objc private func clickFilterButton(_ button: UIButton) {
        button.isSelected.toggle()
        needFilter.toggle()
        updateFilterChain()
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
