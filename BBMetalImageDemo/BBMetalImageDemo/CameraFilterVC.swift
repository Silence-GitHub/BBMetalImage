//
//  CameraFilterVC.swift
//  BBMetalImageDemo
//
//  Created by Kaibo Lu on 4/8/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit
import BBMetalImage

class CameraFilterVC: UIViewController {
    private var camera: BBMetalCamera!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .gray
        
        let metalView = BBMetalView(frame: CGRect(x: 10, y: 100, width: view.bounds.width - 20, height: view.bounds.height - 200),
                                    device: BBMetalDevice.sharedDevice)
        view.addSubview(metalView)
        
        camera = BBMetalCamera()
        camera.add(consumer: metalView)
        camera.start()
    }
}
