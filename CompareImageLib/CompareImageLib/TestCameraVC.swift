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
    private var bbFilters: [BBMetalBaseFilter]!
    private var bbImageView: BBMetalView!
    
    private var gpuCamera: GPUImageVideoCamera!
    private var gpuLookupFilter: GPUImageLookupFilter!
    private var gpuLookupImageSource: GPUImagePicture!
    private var gpuFilters: [GPUImageFilter]!
    private var gpuLookupImageSources: [GPUImagePicture]!
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
            bbCamera.benchmark = true
            
            bbLookupFilter = BBMetalLookupFilter(lookupTable: UIImage(named: "test_lookup")!.bb_metalTexture!)
            
            let contrastFilter = BBMetalContrastFilter(contrast: 3)
            let lookupFilter = BBMetalLookupFilter(lookupTable: UIImage(named: "test_lookup")!.bb_metalTexture!)
            let sharpenFilter = BBMetalSharpenFilter(sharpeness: 1)
            contrastFilter.add(consumer: lookupFilter)
                .add(consumer: sharpenFilter)
            bbFilters = [contrastFilter, lookupFilter, sharpenFilter]
            
            bbImageView = BBMetalView(frame: CGRect(x: 10, y: 100, width: view.bounds.width - 20, height: view.bounds.height - 200))
            view.addSubview(bbImageView)
            
            bbCamera.add(consumer: bbImageView)
            
        case .GPUImage:
            gpuCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSession.Preset.high.rawValue, cameraPosition: .back)
            gpuCamera.outputImageOrientation = .portrait
            gpuCamera.runBenchmark = true
            
            gpuLookupFilter = GPUImageLookupFilter()
            gpuLookupImageSource = GPUImagePicture(image: UIImage(named: "test_lookup")!)
            gpuLookupImageSource.addTarget(gpuLookupFilter, atTextureLocation: 1)
            gpuLookupImageSource.processImage()
            
            let contrastFilter = GPUImageContrastFilter()
            contrastFilter.contrast = 3
            
            let lookupImageSource = GPUImagePicture(image: UIImage(named: "test_lookup")!)!
            let lookupFilter = GPUImageLookupFilter()
            lookupImageSource.addTarget(lookupFilter, atTextureLocation: 1)
            lookupImageSource.processImage()
            
            let sharpenFilter = GPUImageSharpenFilter()
            sharpenFilter.sharpness = 1
            
            contrastFilter.addTarget(lookupFilter)
            lookupFilter.addTarget(sharpenFilter)
            
            gpuFilters = [contrastFilter, lookupFilter, sharpenFilter]
            gpuLookupImageSources = [lookupImageSource]
            
            gpuImageView = GPUImageView(frame: CGRect(x: 10, y: 100, width: view.bounds.width - 20, height: view.bounds.height - 200))
            gpuImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill
            view.addSubview(gpuImageView)
            
            gpuCamera.addTarget(gpuImageView)
        }
        
        let segment = UISegmentedControl(frame: CGRect(x: 10, y: view.bounds.height - 90, width: view.bounds.width - 20, height: 30))
        let titles: [String] = ["Origin", "Filter", "Filters"]
        for i in 0..<titles.count {
            segment.insertSegment(withTitle: titles[i], at: i, animated: false)
        }
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        view.addSubview(segment)
        
        let benchmarkButton = UIButton(frame: CGRect(x: 10, y: view.bounds.height - 60, width: view.bounds.width - 20, height: 30))
        benchmarkButton.backgroundColor = .green
        benchmarkButton.setTitle("Benchmark", for: .normal)
        benchmarkButton.addTarget(self, action: #selector(clickBenchmarkButton(_:)), for: .touchUpInside)
        view.addSubview(benchmarkButton)
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
    
    @objc private func segmentChanged(_ segment: UISegmentedControl) {
        switch type {
        case .BBMetalImage:
            bbCamera.removeAllConsumers()
            bbLookupFilter.removeAllConsumers()
            bbFilters.last?.removeAllConsumers()
        default:
            gpuCamera.removeAllTargets()
            gpuLookupFilter.removeAllTargets()
            gpuFilters.last?.removeAllTargets()
        }
        
        switch segment.selectedSegmentIndex {
        case 0:
            switch type {
            case .BBMetalImage:
                bbCamera.add(consumer: bbImageView)
            case .GPUImage:
                gpuCamera.addTarget(gpuImageView)
            }
        case 1:
            switch type {
            case .BBMetalImage:
                bbCamera.add(consumer: bbLookupFilter)
                    .add(consumer: bbImageView)
            case .GPUImage:
                gpuCamera.addTarget(gpuLookupFilter)
                gpuLookupFilter.addTarget(gpuImageView)
            }
        default:
            switch type {
            case .BBMetalImage:
                bbCamera.add(consumer: bbFilters.first!)
                bbFilters.last?.add(consumer: bbImageView)
            case .GPUImage:
                gpuCamera.addTarget(gpuFilters.first)
                gpuFilters.last?.addTarget(gpuImageView)
            }
        }
        
        switch type {
        case .BBMetalImage:
            bbCamera.resetBenchmark()
        case .GPUImage:
            gpuCamera.resetBenchmarkAverage()
        }
    }
    
    @objc private func clickBenchmarkButton(_ button: UIButton) {
        switch type {
        case .BBMetalImage:
            print("BBMetalImage average frame duration \(bbCamera.averageFrameDuration * 1000) ms")
        default:
            print("GPUImage average frame duration \(gpuCamera.averageFrameDurationDuringCapture()) ms")
        }
    }
}
