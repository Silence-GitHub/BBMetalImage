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
    private var faceView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        let x: CGFloat = 10
        let width: CGFloat = view.bounds.width - 20
        metalView = BBMetalView(frame: CGRect(x: x, y: 100, width: width, height: view.bounds.height - 200))
        view.addSubview(metalView)
        
        let tapMetalView = UITapGestureRecognizer(target: self, action: #selector(tapMetalView(_:)))
        metalView.addGestureRecognizer(tapMetalView)
        
        faceView = UIView(frame: .zero)
        faceView.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        metalView.addSubview(faceView)
        
        let photoButton = UIButton(frame: CGRect(x: x, y: metalView.frame.maxY + 10, width: width, height: 30))
        photoButton.backgroundColor = .blue
        photoButton.setTitle("Take photo", for: .normal)
        photoButton.addTarget(self, action: #selector(clickPhotoButton(_:)), for: .touchUpInside)
        view.addSubview(photoButton)
        
        camera = BBMetalCamera(sessionPreset: .hd1920x1080)
        
        camera.addMetadataOutput(with: [.face])
        camera.metadataObjectDelegate = self
        
        let filter = BBMetalLookupFilter(lookupTable: UIImage(named: "test_lookup")!.bb_metalTexture!)
        
        filter.addCompletedHandler { [weak self] info in
            guard info.isCameraPhoto else { return }
            switch info.result {
            case let .success(texture):
                let image = texture.bb_image
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    guard let self = self else { return }
                    let imageView = UIImageView(frame: self.metalView.frame)
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    imageView.image = image
                    self.view.addSubview(imageView)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        imageView.removeFromSuperview()
                    }
                }
            case let .failure(error):
                print("Error: \(error)")
            }
        }
        
        camera.add(consumer: filter)
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
    
    @objc private func tapMetalView(_ tap: UITapGestureRecognizer) {
        camera.switchCameraPosition()
    }
    
    @objc private func clickPhotoButton(_ button: UIButton) {
        camera.capturePhoto { [weak self] info in
            switch info.result {
            case let .success(texture):
                let image = texture.bb_image
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    let imageView = UIImageView(frame: self.metalView.frame)
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    imageView.image = image
                    self.view.addSubview(imageView)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        imageView.removeFromSuperview()
                    }
                }
            case let .failure(error):
                print("Error: \(error)")
            }
        }
    }
}

extension CameraPhotoFilterVC: BBMetalCameraMetadataObjectDelegate {
    func camera(_ camera: BBMetalCamera, didOutput metadataObjects: [AVMetadataObject]) {
        guard let first = metadataObjects.first else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.faceView.isHidden = true
            }
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.handleMetadataBounds(first.bounds)
        }
    }
    
    private func handleMetadataBounds(_ bounds: CGRect) {
        let imageWidth: CGFloat = 1080
        let imageHeight: CGFloat = 1920
        let aa: CGFloat = imageWidth / imageHeight
        let bb: CGFloat = metalView.bounds.width / metalView.bounds.height
        
        // top x, right y
        let x = camera.position == .front ? bounds.minY : 1 - bounds.maxY
        let y = bounds.origin.x
        
        // x' = sx * x + tx
        // y' = sy * y + ty
        var sx: CGFloat = metalView.bounds.width
        var tx: CGFloat = 0
        var sy: CGFloat = metalView.bounds.height
        var ty: CGFloat = 0
        
        var displayImageWidth = imageWidth
        var displayImageHeight = imageHeight
        
        if aa > bb {
            // Mask left and right
            displayImageWidth = imageHeight * bb
            let maskImageMarginLeft = abs(imageWidth - displayImageWidth) * 0.5
            tx = -maskImageMarginLeft / displayImageWidth * metalView.bounds.width
            sx = (1 + maskImageMarginLeft / displayImageWidth) * metalView.bounds.width - tx
            
        } else {
            // Mask top and bottom
            displayImageHeight = imageWidth / bb
            let maskImageMarginTop = abs(imageHeight - displayImageHeight) * 0.5
            ty = -maskImageMarginTop / displayImageHeight * metalView.bounds.height
            sy = (1 + maskImageMarginTop / displayImageHeight) * metalView.bounds.height - ty
        }
        
        var frame: CGRect = .zero
        frame.origin.x = sx * x + tx
        frame.size.width = bounds.height * imageWidth / displayImageWidth * metalView.bounds.width
        frame.origin.y = sy * y + ty
        frame.size.height = bounds.width * imageHeight / displayImageHeight * metalView.bounds.height
        if frame.minX >= 0,
            frame.maxX <= metalView.bounds.width,
            frame.minY >= 0,
            frame.maxY <= metalView.bounds.height {
            faceView.frame = frame
            faceView.isHidden = false
        } else {
            faceView.isHidden = true
        }
    }
}
