//
//  TestImageVC.swift
//  CompareImageLib
//
//  Created by Kaibo Lu on 4/16/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit
import BBMetalImage
import GPUImage

enum TestLib {
    case BBMetalImage
    case GPUImage
}

class TestImageVC: UIViewController {

    private let type: TestLib
    private var image: UIImage!
    private var imageView: UIImageView!
    
    init(type: TestLib) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image = UIImage(named: "sunflower.jpg")
        
        title = "\(type)"
        view.backgroundColor = .gray
        
        imageView = UIImageView(frame: CGRect(x: 10, y: 100, width: view.bounds.width - 20, height: view.bounds.height - 200))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image
        view.addSubview(imageView)
        
        let segment = UISegmentedControl(frame: CGRect(x: 10, y: view.bounds.height - 90, width: view.bounds.width - 20, height: 30))
        let titles: [String] = ["Origin", "Filter", "Filters"]
        for i in 0..<titles.count {
            segment.insertSegment(withTitle: titles[i], at: i, animated: false)
        }
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        view.addSubview(segment)
    }
    
    @objc private func segmentChanged(_ segment: UISegmentedControl) {
        let start = CACurrentMediaTime()
        switch segment.selectedSegmentIndex {
        case 0:
            imageView.image = image
        case 1:
            imageView.image = filteredImage
        default:
            imageView.image = multifilteredImage
        }
        print("Total time \((CACurrentMediaTime() - start) * 1000) ms")
    }
    
    private var filteredImage: UIImage? {
        switch type {
        case .BBMetalImage:
            return BBMetalLookupFilter(lookupTable: UIImage(named: "test_lookup")!.bb_metalTexture!).filteredImage(with: image)
        case .GPUImage:
            let lookupImageSource = GPUImagePicture(image: UIImage(named: "test_lookup")!)!
            let lookupFilter = GPUImageLookupFilter()
            lookupImageSource.addTarget(lookupFilter, atTextureLocation: 1)
            lookupImageSource.processImage()
            return lookupFilter.image(byFilteringImage: image)
        }
    }
    
    private var multifilteredImage: UIImage? {
        switch type {
        case .BBMetalImage:
            let imageSource = BBMetalStaticImageSource(image: image)
            let contrastFilter = BBMetalContrastFilter(contrast: 3)
            let lookupFilter = BBMetalLookupFilter(lookupTable: UIImage(named: "test_lookup")!.bb_metalTexture!)
            let sharpenFilter = BBMetalSharpenFilter(sharpeness: 1)
            imageSource.add(consumer: contrastFilter)
                .add(consumer: lookupFilter)
                .add(consumer: sharpenFilter)
                .runSynchronously = true
            imageSource.transmitTexture()
            return sharpenFilter.outputTexture?.bb_image
        case .GPUImage:
            let imageSource = GPUImagePicture(image: image)!
            
            let contrastFilter = GPUImageContrastFilter()
            contrastFilter.contrast = 3
            
            let lookupImageSource = GPUImagePicture(image: UIImage(named: "test_lookup")!)!
            let lookupFilter = GPUImageLookupFilter()
            lookupImageSource.addTarget(lookupFilter, atTextureLocation: 1)
            lookupImageSource.processImage()
            
            let sharpenFilter = GPUImageSharpenFilter()
            sharpenFilter.sharpness = 1
            
            imageSource.addTarget(contrastFilter)
            contrastFilter.addTarget(lookupFilter)
            lookupFilter.addTarget(sharpenFilter)
            sharpenFilter.useNextFrameForImageCapture()
            imageSource.processImage()
            return sharpenFilter.imageFromCurrentFramebuffer()
        }
    }
}
