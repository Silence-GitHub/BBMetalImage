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

    @available(iOS 13.0, *)
    private var camera: BBMetalMultipleCamera! {
        _camera as? BBMetalMultipleCamera
    }
    private var _camera: AnyObject!
    
    private var pipFilter: PiPFilter!
    
    private var metalView: BBMetalView!
    
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
        
        pipFilter = PiPFilter(pipFrame: .init(x: 0.6, y: 0.6, z: 0.3, w: 0.3))
        
        let x: CGFloat = 10
        let width: CGFloat = view.bounds.width - 20
        metalView = BBMetalView(frame: CGRect(x: x, y: 100, width: width, height: view.bounds.height - 230))
        view.addSubview(metalView)
        
        if #available(iOS 13.0, *) {
            camera.backCamera.add(consumer: pipFilter)
            camera.frontCamera.add(consumer: pipFilter)
                .add(consumer: metalView)
        }
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

}
