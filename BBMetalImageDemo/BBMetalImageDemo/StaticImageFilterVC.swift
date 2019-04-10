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
        case .brightness: return image.bb_brightnessFiltered(withBrightness: 0.15)
        case .exposure: return image.bb_exposureFiltered(withExposure: 0.5)
        case .contrast: return image.bb_contrastFiltered(withContrast: 1.5)
        case .saturation: return image.bb_saturationFiltered(withSaturation: 2)
        case .gamma: return image.bb_gammaFiltered(withGamma: 1.5)
        case .levels: return image.bb_levelsFiltered(withMinimum: .red)
        case .colorMatrix:
            var matrix: BBMetalMatrix4x4 = .identity
            matrix.m12 = 1
            matrix.m32 = 1
            matrix.m42 = 1
            return image.bb_colorMatrixFiltered(withColorMatrix: matrix, intensity: 1)
        case .rgba: return image.bb_rgbaFiltered(withRed: 1.2, green: 1, blue: 1, alpha: 1)
        case .hue: return image.bb_hueFiltered(withHue: 90)
        case .vibrance: return image.bb_vibranceFiltered(withVibrance: 1)
        case .whiteBalance: return image.bb_whiteBalanceFiltered(withTemperature: 7000, tint: 0)
        case .highlightShadow: return image.bb_highlightShadowFiltered(withShadows: 0.5, highlights: 0.5)
        case .highlightShadowTint: return image.bb_HighlightShadowTintFiltered(withShadowTintColor: .blue,
                                                                               shadowTintIntensity: 0.5,
                                                                               highlightTintColor: .red,
                                                                               highlightTintIntensity: 0.5)
        case .lookup:
            let url = Bundle.main.url(forResource: "test_lookup", withExtension: "png")!
            let data = try! Data(contentsOf: url)
            return image.bb_lookupFiltered(withLookupTable: data.bb_metalTexture!, intensity: 1)
        case .colorInversion: return image.bb_colorInversionFiltered()
        case .monochrome: return image.bb_monochromeFiltered(withColor: BBMetalColor(red: 0.7, green: 0.6, blue: 0.5), intensity: 1)
        case .falseColor: return image.bb_falseColorFiltered(withFirstColor: .red, secondColor: .blue)
        case .haze: return image.bb_hazeFiltered(withDistance: 0.2, slope: 0)
        case .luminance: return image.bb_luminanceFiltered()
        case .luminanceThreshold: return image.bb_luminanceThresholdFiltered(withThreshold: 0.6)
        case .chromaKey: return image.bb_chromaKeyFiltered(withThresholdSensitivity: 0.4, smoothing: 0.1, colorToReplace: .blue)
        case .sharpen: return image.bb_sharpenFiltered(withSharpeness: 0.5)
        case .gaussianBlur: return image.bb_gaussianBlurFiltered(withSigma: 3)
        case .boxBlur: return image.bb_boxBlurFiltered(withKernelWidth: 25, kernelHeight: 65)
        case .zoomBlur: return image.bb_zoomBlurFiltered(withBlurSize: 3, blurCenter: BBMetalPosition(x: 0.35, y: 0.55))
        case .motionBlur: return image.bb_motionBlurFiltered(withBlurSize: 5, blurAngle: 30)
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
        }
    }
    
    private func topBlendImage(withAlpha alpha: Float) -> UIImage {
        return UIImage(named: "multicolour_flowers.jpg")!.bb_rgbaFiltered(alpha: alpha)!
    }
}
