//
//  UIImage+Filter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/2/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

public extension UIImage {
    public func bb_brightnessFiltered(withBrightness brightness: Float = 0) -> UIImage? {
        return filtered(with: BBMetalBrightnessFilter(brightness: brightness))
    }
    
    public func bb_exposureFiltered(withExposure exposure: Float = 0) -> UIImage? {
        return filtered(with: BBMetalExposureFilter(exposure: exposure))
    }
    
    public func bb_contrastFiltered(withContrast contrast: Float = 1) -> UIImage? {
        return filtered(with: BBMetalContrastFilter(contrast: contrast))
    }
    
    public func bb_saturationFiltered(withSaturaton saturation: Float = 1) -> UIImage? {
        return filtered(with: BBMetalSaturationFilter(saturation: saturation))
    }
    
    public func bb_lookupFiltered(withLookupTable lookupTable: MTLTexture, intensity: Float = 1) -> UIImage? {
        return filtered(with: BBMetalLookupFilter(lookupTable: lookupTable, intensity: intensity))
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
