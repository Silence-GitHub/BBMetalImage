//
//  VideoFilterVC.swift
//  BBMetalImageDemo
//
//  Created by Kaibo Lu on 4/25/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit
import BBMetalImage

class VideoFilterVC: UIViewController {
    private var videoSource: BBMetalVideoSource!
    private var metalView: BBMetalView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .gray
        
        metalView = BBMetalView(frame: CGRect(x: 10, y: 100, width: view.bounds.width - 20, height: view.bounds.height - 200),
                                device: BBMetalDevice.sharedDevice)
        view.addSubview(metalView)
        
        let button = UIButton(frame: CGRect(x: 10, y: view.bounds.height - 90, width: view.bounds.width - 20, height: 30))
        button.backgroundColor = .blue
        button.setTitle("Add filter", for: .normal)
        button.setTitle("Remove filer", for: .selected)
        button.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
        view.addSubview(button)
        
        let url = Bundle.main.url(forResource: "test_video", withExtension: "MOV")!
        videoSource = BBMetalVideoSource(url: url)
        videoSource.add(consumer: metalView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoSource.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoSource.cancel()
    }
    
    @objc private func clickButton(_ button: UIButton) {
        button.isSelected = !button.isSelected
        videoSource.removeAllConsumers()
        if button.isSelected {
            let filter = BBMetalColorInversionFilter()
            videoSource.add(consumer: filter).add(consumer: metalView)
        } else {
            videoSource.add(consumer: metalView)
        }
    }
}
