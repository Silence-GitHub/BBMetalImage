//
//  BBMetalMultipleCamera.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 10/5/21.
//  Copyright © 2021 Kaibo Lu. All rights reserved.
//

import UIKit
import AVFoundation

@available(iOS 13.0, *)
public class BBMetalMultipleCamera {

    public static var isMultiCamSupported: Bool { AVCaptureMultiCamSession.isMultiCamSupported }
    
    private let session: AVCaptureMultiCamSession
    
    public let backCamera: BBMetalCamera
    public let frontCamera: BBMetalCamera
    
    public init?() {
        session = .init()
        
        guard let backCamera = BBMetalCamera(captureSession: session, position: .back) else { return nil }
        self.backCamera = backCamera
        
        guard let frontCamera = BBMetalCamera(captureSession: session, position: .front) else { return nil }
        self.frontCamera = frontCamera
    }

}
