//
//  UIImage+Filter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/2/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

public extension UIImage {
    public func bb_brightnessFiltered(withBrightness brightness: Float) -> UIImage? {
        return filtered(with: BBMetalBrightnessFilter(brightness: brightness))
    }
    
    public func bb_exposureFiltered(withExposure exposure: Float) -> UIImage? {
        return filtered(with: BBMetalExposureFilter(exposure: exposure))
    }
    
    public func bb_luminanceFiltered() -> UIImage? {
        return filtered(with: BBMetalLuminanceFilter())
    }
    
    private func filtered(with filter: BBMetalBaseFilter) -> UIImage? {
        let source = BBMetalStaticImageSource(image: self)
        filter.runSynchronously = true
        source.add(consumer: filter)
        source.transmitTexture()
        return filter.outputTexture?.bb_image
    }
}
