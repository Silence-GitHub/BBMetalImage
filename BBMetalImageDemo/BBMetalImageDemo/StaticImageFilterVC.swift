//
//  StaticImageFilterVC.swift
//  BBMetalImageDemo
//
//  Created by Kaibo Lu on 4/2/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit
import BBMetalImage

class StaticImageFilterVC: UIViewController {

    private var image: UIImage!
    
    private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        image = UIImage(named: "multicolour_flowers.jpg")
        
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
            let source = BBMetalStaticImageSource(image: image)
            let filter = BBMetalLuminanceFilter()
            filter.runSynchronously = true
            source.add(consumer: filter)
            source.transmitTexture()
            imageView.image = filter.outputTexture?.bb_image
        } else {
            imageView.image = image
        }
    }
}
