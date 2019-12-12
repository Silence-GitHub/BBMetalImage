//
//  RecordUIVC.swift
//  BBMetalImageDemo
//
//  Created by Kaibo Lu on 12/11/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit
import CoreMedia
import BBMetalImage

class RecordUIVC: UIViewController {
    private var animationView: UIView!
    private var icon: UIImageView!
    
    private var displayLink: CADisplayLink!
    private var step: CGFloat = 1
    
    private var uiSource: BBMetalUISource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        animationView = UIView(frame: CGRect(x: 10, y: 100, width: view.bounds.width - 20, height: 100))
        animationView.backgroundColor = .blue
        view.addSubview(animationView)
        
        icon = UIImageView(frame: CGRect(x: 0, y: 25, width: 50, height: 50))
        icon.backgroundColor = .red
        animationView.addSubview(icon)
        
        displayLink = CADisplayLink(target: self, selector: #selector(refreshDisplayLink(_:)))
        displayLink.isPaused = true
        displayLink.add(to: .main, forMode: .common)
        
        var frame = animationView.frame
        frame.origin.y = frame.maxY + 10
        frame.size.height += 20
        let metalView = BBMetalView(frame: frame)
        metalView.bb_textureContentMode = .aspectRatioFit
        view.addSubview(metalView)
        
        uiSource = BBMetalUISource(view: animationView)
        uiSource.add(consumer: metalView)
        
        frame.origin.y = frame.maxY + 10
        frame.size.height = 50
        let button = UIButton(frame: frame)
        button.backgroundColor = .blue
        button.setTitle("Start recording", for: .normal)
        button.setTitle("Finish recording", for: .selected)
        button.addTarget(self, action: #selector(clickRecordButton(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        displayLink.invalidate()
    }
    
    @objc private func refreshDisplayLink(_ link: CADisplayLink) {
        icon.center.x += step
        if icon.frame.maxX > animationView.bounds.width {
            icon.frame.origin.x = animationView.bounds.width - icon.frame.width
            step = -1
        } else if icon.frame.minX < 0 {
            icon.frame.origin.x = 0
            step = 1
        }
        uiSource.transmitTexture(with: .invalid)
    }
    
    @objc private func clickRecordButton(_ button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            displayLink.isPaused = false
        } else {
            displayLink.isPaused = true
        }
    }
}
