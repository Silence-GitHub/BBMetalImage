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

    private let type: FilterType
    private var image: UIImage!
    
    private var imageView: UIImageView!
    
    init(type: FilterType) {
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
            imageView.image = filteredImage
        } else {
            imageView.image = image
        }
    }
    
    private var filteredImage: UIImage? {
        switch type {
        case .brightness: return BBMetalBrightnessFilter(brightness: 0.15).filteredImage(with: image)
        case .exposure: return BBMetalExposureFilter(exposure: 0.5).filteredImage(with: image)
        case .contrast: return BBMetalContrastFilter(contrast: 1.5).filteredImage(with: image)
        case .saturation: return BBMetalSaturationFilter(saturation: 2).filteredImage(with: image)
        case .gamma: return BBMetalGammaFilter(gamma: 1.5).filteredImage(with: image)
        case .levels: return BBMetalLevelsFilter(minimum: .red).filteredImage(with: image)
        case .colorMatrix:
            var matrix: BBMetalMatrix4x4 = .identity
            matrix.m12 = 1
            matrix.m32 = 1
            matrix.m42 = 1
            return BBMetalColorMatrixFilter(colorMatrix: matrix).filteredImage(with: image)
        case .rgba: return BBMetalRGBAFilter(red: 1.2).filteredImage(with: image)
        case .hue: return BBMetalHueFilter(hue: 90).filteredImage(with: image)
        case .vibrance: return BBMetalVibranceFilter(vibrance: 1).filteredImage(with: image)
        case .whiteBalance: return BBMetalWhiteBalanceFilter(temperature: 7000).filteredImage(with: image)
        case .highlightShadow: return BBMetalHighlightShadowFilter(shadows: 0.5, highlights: 0.5).filteredImage(with: image)
        case .highlightShadowTint: return BBMetalHighlightShadowTintFilter(shadowTintColor: .blue,
                                                                           shadowTintIntensity: 0.5,
                                                                           highlightTintColor: .red,
                                                                           highlightTintIntensity: 0.5).filteredImage(with: image)
        case .lookup:
            let url = Bundle.main.url(forResource: "test_lookup", withExtension: "png")!
            let data = try! Data(contentsOf: url)
            return BBMetalLookupFilter(lookupTable: data.bb_metalTexture!).filteredImage(with: image)
        case .colorInversion: return BBMetalColorInversionFilter().filteredImage(with: image)
        case .monochrome: return BBMetalMonochromeFilter(color: BBMetalColor(red: 0.7, green: 0.6, blue: 0.5), intensity: 1).filteredImage(with: image)
        case .falseColor: return BBMetalFalseColorFilter().filteredImage(with: image)
        case .haze: return BBMetalHazeFilter(distance: 0.2).filteredImage(with: image)
        case .luminance: return BBMetalLuminanceFilter().filteredImage(with: image)
        case .luminanceThreshold: return BBMetalLuminanceThresholdFilter(threshold: 0.6).filteredImage(with: image)
        case .chromaKey: return BBMetalChromaKeyFilter(colorToReplace: .blue).filteredImage(with: image)
        case .crop: return BBMetalCropFilter(rect: BBMetalRect(x: 0.25, y: 0.5, width: 0.5, height: 0.5)).filteredImage(with: image)
        case .resize: return BBMetalResizeFilter(size: BBMetalSize(width: 0.5, height: 0.8)).filteredImage(with: image)
        case .rotate: return BBMetalRotateFilter(angle: -120, fitSize: true).filteredImage(with: image)
        case .flip: return BBMetalFlipFilter(horizontal: true, vertical: true).filteredImage(with: image)
        case .sharpen: return BBMetalSharpenFilter(sharpeness: 0.5).filteredImage(with: image)
        case .unsharpMask: return BBMetalUnsharpMaskFilter(intensity: 4).filteredImage(with: image)
        case .gaussianBlur: return BBMetalGaussianBlurFilter(sigma: 3).filteredImage(with: image)
        case .boxBlur: return BBMetalBoxBlurFilter(kernelWidth: 25, kernelHeight: 65).filteredImage(with: image)
        case .zoomBlur: return BBMetalZoomBlurFilter(blurSize: 3, blurCenter: BBMetalPosition(x: 0.35, y: 0.55)).filteredImage(with: image)
        case .motionBlur: return BBMetalMotionBlurFilter(blurSize: 5, blurAngle: 30).filteredImage(with: image)
        case .tiltShift: return BBMetalTiltShiftFilter().filteredImage(with: image)
        case .normalBlend: return image.bb_normalBlendFiltered(withImage: topBlendImage(withAlpha: 0.1))
        case .chromaKeyBlend: return image.bb_chromaKeyBlendFiltered(withThresholdSensitivity: 0.4,
                                                                     smoothing: 0.1,
                                                                     colorToReplace: .blue,
                                                                     image: topBlendImage(withAlpha: 0.1))
        case .dissolveBlend: return image.bb_dissolveBlendFiltered(withMixturePercent: 0.3, image: topBlendImage(withAlpha: 0.1))
        case .addBlend: return image.bb_addBlendFiltered(withImage: topBlendImage(withAlpha: 0.5))
        case .subtractBlend: return image.bb_subtractBlendFiltered(withImage: topBlendImage(withAlpha: 0.1))
        case .multiplyBlend: return image.bb_multiplyBlendFiltered(withImage: topBlendImage(withAlpha: 0.1))
        case .divideBlend: return image.bb_divideBlendFiltered(withImage: topBlendImage(withAlpha: 0.5))
        case .overlayBlend: return image.bb_overlayBlendFiltered(withImage: topBlendImage(withAlpha: 0.1))
        case .darkenBlend: return image.bb_darkenBlendFiltered(withImage: topBlendImage(withAlpha: 0.5))
        case .lightenBlend: return image.bb_lightenBlendFiltered(withImage: topBlendImage(withAlpha: 0.1))
        case .colorBlend: return image.bb_colorBlendFiltered(withImage: topBlendImage(withAlpha: 1))
        case .colorBurnBlend: return image.bb_colorBurnBlendFiltered(withImage: topBlendImage(withAlpha: 0.1))
        case .colorDodgeBlend: return image.bb_colorDodgeBlendFiltered(withImage: topBlendImage(withAlpha: 0.5))
        case .screenBlend: return image.bb_screenBlendFiltered(withImage: topBlendImage(withAlpha: 0.1))
        case .exclusionBlend: return image.bb_exclusionBlendFiltered(withImage: topBlendImage(withAlpha: 0.1))
        case .differenceBlend: return image.bb_differenceBlendFiltered(withImage: topBlendImage(withAlpha: 0.1))
        case .hardLightBlend: return image.bb_hardLightBlendFiltered(withImage: topBlendImage(withAlpha: 0.1))
        case .softLightBlend: return image.bb_softLightBlendFiltered(withImage: topBlendImage(withAlpha: 0.1))
        case .alphaBlend: return image.bb_alphaBlendFiltered(withMixturePercent: 0.5, image: topBlendImage(withAlpha: 0.5))
        case .sourceOverBlend: return image.bb_sourceOverBlendFiltered(withImage: topBlendImage(withAlpha: 0.5))
        case .hueBlend: return image.bb_hueBlendFiltered(withImage: topBlendImage(withAlpha: 1))
        case .saturationBlend: return image.bb_saturationBlendFiltered(withImage: topBlendImage(withAlpha: 1))
        case .luminosityBlend: return image.bb_luminosityBlendFiltered(withImage: topBlendImage(withAlpha: 0.5))
        case .linearBurnBlend: return image.bb_linearBurnBlendFiltered(withImage: topBlendImage(withAlpha: 0.1))
        case .maskBlend: return image.bb_maskBlendFiltered(withImage: topBlendImage(withAlpha: 1))
        case .pixellate: return image.bb_pixellateFiltered(withFractionalWidth: 0.05)
        case .polarPixellate: return image.bb_polarPixellateFiltered(withPixelSize: BBMetalSize(width: 0.05, height: 0.07), center: BBMetalPosition(x: 0.35, y: 0.55))
        case .polkaDot: return image.bb_polkaDotFiltered(withFractionalWidth: 0.05, dotScaling: 0.9)
        case .halftone: return image.bb_halftoneFiltered(withFractionalWidth: 0.01)
        case .crosshatch: return image.bb_crosshatchFiltered(withCrosshatchSpacing: 0.01, lineWidth: 0.003)
        case .sketch: return image.bb_sketchFiltered(withEdgeStrength: 1)
        case .thresholdSketch: return image.bb_thresholdSketchFiltered(withEdgeStrength: 1, threshold: 0.15)
        case .toon: return image.bb_toonFiltered(withThreshold: 0.2, quantizationLevels: 10)
        case .posterize: return image.bb_posterizeFiltered(withColorLevels: 10)
        case .swirl: return image.bb_swirlFiltered(withCenter: BBMetalPosition(x: 0.35, y: 0.55), radius: 0.25, angle: 1)
        }
    }
    
    private func topBlendImage(withAlpha alpha: Float) -> UIImage {
        let image = UIImage(named: "multicolour_flowers.jpg")!
        if alpha == 1 { return image }
        return BBMetalRGBAFilter(alpha: alpha).filteredImage(with: image)!
    }
}
