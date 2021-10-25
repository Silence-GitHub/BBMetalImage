//
//  DepthCameraLuminanceVC.swift
//  BBMetalImageDemo
//
//  Created by Kaibo Lu on 10/25/21.
//  Copyright © 2021 Kaibo Lu. All rights reserved.
//

import UIKit
import BBMetalImage

class DepthCameraLuminanceVC: UIViewController {

    private var camera: BBMetalCamera!
    private var filter: BBMetalBaseFilter!
    private var metalView: BBMetalView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        if #available(iOS 11.0, *) {
            camera = BBMetalCamera(deviceType: .builtInDualCamera, position: .unspecified)
            if camera == nil,
               #available(iOS 13.0, *) {
                camera = BBMetalCamera(deviceType: .builtInDualWideCamera, position: .unspecified)
            }
            if camera == nil,
               #available(iOS 11.1, *) {
                camera = BBMetalCamera(deviceType: .builtInTrueDepthCamera, position: .unspecified)
            }
            if camera != nil { camera.canGetDepthData = true }
        }
        
        guard #available(iOS 11.0, *),
              camera != nil,
              camera.canGetDepthData
        else {
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
        
        camera.add(depthConsumer: metalView)
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
        button.isSelected.toggle()
        camera.removeAllDepthConsumers()
        if button.isSelected {
            filter = BBMetalDepthLuminanceFilter()
            camera.add(depthConsumer: filter)
                .add(consumer: metalView)
        } else {
            camera.add(depthConsumer: metalView)
        }
    }

}
