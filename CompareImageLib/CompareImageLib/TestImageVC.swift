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
        
        let button = UIButton(frame: CGRect(x: 10, y: view.bounds.height - 90, width: view.bounds.width - 20, height: 30))
        button.backgroundColor = .blue
        button.setTitle("Add filter", for: .normal)
        button.setTitle("Remove filer", for: .selected)
        button.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc private func clickButton(_ button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            let start = CACurrentMediaTime()
            imageView.image = filteredImage
            print("\(type) total time \(CACurrentMediaTime() - start)")
        } else {
            imageView.image = image
        }
    }
    
    private var filteredImage: UIImage? {
        switch type {
        case .BBMetalImage:
            return image.bb_lookupFiltered(withLookupTable: UIImage(named: "test_lookup")!.bb_metalTexture!)
        case .GPUImage:
            let lookupImageSource = GPUImagePicture(image: UIImage(named: "test_lookup")!)!
            let lookupFilter = GPUImageLookupFilter()
            lookupImageSource.addTarget(lookupFilter, atTextureLocation: 1)
            lookupImageSource.processImage()
            let imageSource = GPUImagePicture(image: image)!
            imageSource.addTarget(lookupFilter)
            lookupFilter.useNextFrameForImageCapture()
            imageSource.processImage()
            return lookupFilter.imageFromCurrentFramebuffer()
        }
    }
}
