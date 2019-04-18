    //
//  TestCameraVC.swift
//  CompareImageLib
//
//  Created by Kaibo Lu on 4/17/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit
import BBMetalImage
import GPUImage

class TestCameraVC: UIViewController {
    
    private let type: TestLib
    
    private var bbCamera: BBMetalCamera!
    private var bbLookupFilter: BBMetalLookupFilter!
    private var bbImageView: BBMetalView!
    
    private var gpuCamera: GPUImageVideoCamera!
    private var gpuLookupFilter: GPUImageLookupFilter!
    private var gpuLookupImageSource: GPUImagePicture!
    private var gpuImageView: GPUImageView!
    
    init(type: TestLib) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(type)"
        view.backgroundColor = .gray
        
        switch type {
        case .BBMetalImage:
            bbCamera = BBMetalCamera(sessionPreset: .high)
            bbLookupFilter = BBMetalLookupFilter(lookupTable: UIImage(named: "test_lookup")!.bb_metalTexture!)
            bbImageView = BBMetalView(frame: CGRect(x: 10, y: 100, width: view.bounds.width - 20, height: view.bounds.height - 200))
            view.addSubview(bbImageView)
            
            bbCamera.add(consumer: bbImageView)
            
        case .GPUImage:
            gpuCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSession.Preset.high.rawValue, cameraPosition: .back)
            gpuCamera.outputImageOrientation = .portrait
            
            gpuLookupFilter = GPUImageLookupFilter()
            gpuLookupImageSource = GPUImagePicture(image: UIImage(named: "test_lookup")!)
            gpuLookupImageSource.addTarget(gpuLookupFilter, atTextureLocation: 1)
            gpuLookupImageSource.processImage()
            
            gpuImageView = GPUImageView(frame: CGRect(x: 10, y: 100, width: view.bounds.width - 20, height: view.bounds.height - 200))
            gpuImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill
            view.addSubview(gpuImageView)
            
            gpuCamera.addTarget(gpuImageView)
        }
        
        let button = UIButton(frame: CGRect(x: 10, y: view.bounds.height - 90, width: view.bounds.width - 20, height: 30))
        button.backgroundColor = .blue
        button.setTitle("Add filter", for: .normal)
        button.setTitle("Remove filer", for: .selected)
        button.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        switch type {
        case .BBMetalImage:
            bbCamera.start()
        case .GPUImage:
            gpuCamera.startCapture()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        switch type {
        case .BBMetalImage:
            bbCamera.stop()
        case .GPUImage:
            gpuCamera.stopCapture()
        }
    }
    
    @objc private func clickButton(_ button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            switch type {
            case .BBMetalImage:
                bbCamera.removeAllConsumers()
                bbCamera.add(consumer: bbLookupFilter).add(consumer: bbImageView)
            case .GPUImage:
                gpuCamera.removeAllTargets()
                gpuCamera.addTarget(gpuLookupFilter)
                gpuLookupFilter.addTarget(gpuImageView)
            }
        } else {
            switch type {
            case .BBMetalImage:
                bbCamera.removeAllConsumers()
                bbLookupFilter.removeAllConsumers()
                bbCamera.add(consumer: bbImageView)
            case .GPUImage:
                gpuCamera.removeAllTargets()
                gpuLookupFilter.removeAllTargets()
                gpuCamera.addTarget(gpuImageView)
            }
        }
    }
}
