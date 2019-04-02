//
//  UIImage+Filter.swift
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/2/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

public extension UIImage {
    public func bb_luminanceFiltered() -> UIImage? {
        let source = BBMetalStaticImageSource(image: self)
        let filter = BBMetalLuminanceFilter()
        filter.runSynchronously = true
        source.add(consumer: filter)
        source.transmitTexture()
        return filter.outputTexture?.bb_image
    }
}
