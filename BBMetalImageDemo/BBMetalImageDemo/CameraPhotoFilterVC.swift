//
//  CameraPhotoFilterVC.swift
//  BBMetalImageDemo
//
//  Created by Kaibo Lu on 5/13/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit
import AVFoundation
import BBMetalImage

class CameraPhotoFilterVC: UIViewController {
    private var camera: BBMetalCamera!
    private var metalView: BBMetalView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        let x: CGFloat = 10
        let width: CGFloat = view.bounds.width - 20
        metalView = BBMetalView(frame: CGRect(x: x, y: 100, width: width, height: view.bounds.height - 200),
                                device: BBMetalDevice.sharedDevice)
        view.addSubview(metalView)
        
        let photoButton = UIButton(frame: CGRect(x: x, y: metalView.frame.maxY + 10, width: width, height: 30))
        photoButton.backgroundColor = .blue
        photoButton.setTitle("Take photo", for: .normal)
        photoButton.addTarget(self, action: #selector(clickPhotoButton(_:)), for: .touchUpInside)
        view.addSubview(photoButton)
        
        camera = BBMetalCamera(sessionPreset: .hd1920x1080)
        camera.canTakePhoto = true
        camera.photoDelegate = self
        camera.add(consumer: BBMetalLookupFilter(lookupTable: UIImage(named: "test_lookup")!.bb_metalTexture!))
            .add(consumer: metalView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        camera.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        camera.stop()
    }
    
    @objc private func clickPhotoButton(_ button: UIButton) {
        camera.takePhoto()
    }
}

extension CameraPhotoFilterVC: BBMetalCameraPhotoDelegate {
    func camera(_ camera: BBMetalCamera, didOutput texture: MTLTexture) {
        // In main thread
        let filter = BBMetalLookupFilter(lookupTable: UIImage(named: "test_lookup")!.bb_metalTexture!)
        let imageView = UIImageView(frame: metalView.frame)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = filter.filteredImage(with: texture.bb_image!)
        view.addSubview(imageView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            imageView.removeFromSuperview()
        }
    }
    
    func camera(_ camera: BBMetalCamera, didFail error: Error) {
        // In main thread
        print("Fail taking photo. Error: \(error)")
    }
}
