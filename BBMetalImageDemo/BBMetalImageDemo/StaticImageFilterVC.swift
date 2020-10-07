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
            var matrix: matrix_float4x4 = .identity
            matrix[0][1] = 1
            matrix[2][1] = 1
            matrix[3][1] = 1
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
        case .erosion: return BBMetalErosionFilter(pixelRadius: 2).filteredImage(with: image)
        case .rgbaErosion: return BBMetalRGBAErosionFilter(pixelRadius: 2).filteredImage(with: image)
        case .dilation: return BBMetalDilationFilter(pixelRadius: 2).filteredImage(with: image)
        case .rgbaDilation: return BBMetalRGBADilationFilter(pixelRadius: 2).filteredImage(with: image)
        case .chromaKey: return BBMetalChromaKeyFilter(colorToReplace: .blue).filteredImage(with: image)
        case .crop: return BBMetalCropFilter(rect: BBMetalRect(x: 0.25, y: 0.5, width: 0.5, height: 0.5)).filteredImage(with: image)
        case .resize: return BBMetalResizeFilter(size: BBMetalSize(width: 0.5, height: 0.8)).filteredImage(with: image)
        case .rotate: return BBMetalRotateFilter(angle: -120, fitSize: true).filteredImage(with: image)
        case .flip: return BBMetalFlipFilter(horizontal: true, vertical: true).filteredImage(with: image)
        case .transform:
            let transform = CGAffineTransform(translationX: 320, y: 0).rotated(by: .pi / 180 * 30)
            return BBMetalTransformFilter(transform: transform, fitSize: true).filteredImage(with: image)
        case .sharpen: return BBMetalSharpenFilter(sharpeness: 0.5).filteredImage(with: image)
        case .unsharpMask: return BBMetalUnsharpMaskFilter(intensity: 4).filteredImage(with: image)
        case .gaussianBlur: return BBMetalGaussianBlurFilter(sigma: 3).filteredImage(with: image)
        case .boxBlur: return BBMetalBoxBlurFilter(kernelWidth: 25, kernelHeight: 65).filteredImage(with: image)
        case .zoomBlur: return BBMetalZoomBlurFilter(blurSize: 3, blurCenter: BBMetalPosition(x: 0.35, y: 0.55)).filteredImage(with: image)
        case .motionBlur: return BBMetalMotionBlurFilter(blurSize: 5, blurAngle: 30).filteredImage(with: image)
        case .tiltShift: return BBMetalTiltShiftFilter().filteredImage(with: image)
        case .normalBlend: return BBMetalNormalBlendFilter().filteredImage(with: image, topBlendImage(withAlpha: 0.1))
        case .chromaKeyBlend: return BBMetalChromaKeyBlendFilter(colorToReplace: .blue).filteredImage(with: image, topBlendImage(withAlpha: 0.1))
        case .dissolveBlend: return BBMetalDissolveBlendFilter(mixturePercent: 0.3).filteredImage(with: image, topBlendImage(withAlpha: 0.1))
        case .addBlend: return BBMetalAddBlendFilter().filteredImage(with: image, topBlendImage(withAlpha: 0.5))
        case .subtractBlend: return BBMetalSubtractBlendFilter().filteredImage(with: image, topBlendImage(withAlpha: 0.1))
        case .multiplyBlend: return BBMetalMultiplyBlendFilter().filteredImage(with: image, topBlendImage(withAlpha: 0.1))
        case .divideBlend: return BBMetalDivideBlendFilter().filteredImage(with: image, topBlendImage(withAlpha: 0.5))
        case .overlayBlend: return BBMetalOverlayBlendFilter().filteredImage(with: image, topBlendImage(withAlpha: 0.1))
        case .darkenBlend: return BBMetalDarkenBlendFilter().filteredImage(with: image, topBlendImage(withAlpha: 0.5))
        case .lightenBlend: return BBMetalLightenBlendFilter().filteredImage(with: image, topBlendImage(withAlpha: 0.1))
        case .colorBlend: return BBMetalColorBlendFilter().filteredImage(with: image, topBlendImage(withAlpha: 1))
        case .colorBurnBlend: return BBMetalColorBurnBlendFilter().filteredImage(with: image, topBlendImage(withAlpha: 0.1))
        case .colorDodgeBlend: return BBMetalColorDodgeBlendFilter().filteredImage(with: image, topBlendImage(withAlpha: 0.5))
        case .screenBlend: return BBMetalScreenBlendFilter().filteredImage(with: image, topBlendImage(withAlpha: 0.1))
        case .exclusionBlend: return BBMetalExclusionBlendFilter().filteredImage(with: image, topBlendImage(withAlpha: 0.1))
        case .differenceBlend: return BBMetalDifferenceBlendFilter().filteredImage(with: image, topBlendImage(withAlpha: 0.1))
        case .hardLightBlend: return BBMetalHardLightBlendFilter().filteredImage(with: image, topBlendImage(withAlpha: 0.1))
        case .softLightBlend: return BBMetalSoftLightBlendFilter().filteredImage(with: image, topBlendImage(withAlpha: 0.1))
        case .alphaBlend: return BBMetalAlphaBlendFilter(mixturePercent: 0.5).filteredImage(with: image, topBlendImage(withAlpha: 0.5))
        case .sourceOverBlend: return BBMetalSourceOverBlendFilter().filteredImage(with: image, topBlendImage(withAlpha: 0.5))
        case .hueBlend: return BBMetalHueBlendFilter().filteredImage(with: image, topBlendImage(withAlpha: 1))
        case .saturationBlend: return BBMetalSaturationBlendFilter().filteredImage(with: image, topBlendImage(withAlpha: 1))
        case .luminosityBlend: return BBMetalLuminosityBlendFilter().filteredImage(with: image, topBlendImage(withAlpha: 0.5))
        case .linearBurnBlend: return BBMetalLinearBurnBlendFilter().filteredImage(with: image, topBlendImage(withAlpha: 0.1))
        case .maskBlend: return BBMetalMaskBlendFilter().filteredImage(with: image, topBlendImage(withAlpha: 1))
        case .pixellate: return BBMetalPixellateFilter().filteredImage(with: image)
        case .polarPixellate: return BBMetalPolarPixellateFilter(pixelSize: BBMetalSize(width: 0.05, height: 0.07), center: BBMetalPosition(x: 0.35, y: 0.55)).filteredImage(with: image)
        case .polkaDot: return BBMetalPolkaDotFilter().filteredImage(with: image)
        case .halftone: return BBMetalHalftoneFilter().filteredImage(with: image)
        case .crosshatch: return BBMetalCrosshatchFilter(crosshatchSpacing: 0.01).filteredImage(with: image)
        case .sketch: return BBMetalSketchFilter().filteredImage(with: image)
        case .thresholdSketch: return BBMetalThresholdSketchFilter(threshold: 0.15).filteredImage(with: image)
        case .toon: return BBMetalToonFilter().filteredImage(with: image)
        case .posterize: return BBMetalPosterizeFilter().filteredImage(with: image)
        case .vignette: return BBMetalVignetteFilter().filteredImage(with: image)
        case .kuwahara: return BBMetalKuwaharaFilter().filteredImage(with: image)
        case .swirl: return BBMetalSwirlFilter(center: BBMetalPosition(x: 0.35, y: 0.55), radius: 0.25).filteredImage(with: image)
        case .bulge: return BBMetalBulgeFilter(center: BBMetalPosition(x: 0.35, y: 0.55)).filteredImage(with: image)
        case .pinch: return BBMetalPinchFilter(center: BBMetalPosition(x: 0.35, y: 0.55)).filteredImage(with: image)
        case .convolution3x3: return BBMetalConvolution3x3Filter(convolution: simd_float3x3(rows: [SIMD3<Float>(-1, 0, 1),
                                                                                                   SIMD3<Float>(-2, 0, 2),
                                                                                                   SIMD3<Float>(-1, 0, 1)])).filteredImage(with: image)
        case .emboss: return BBMetalEmbossFilter(intensity: 1).filteredImage(with: image)
        case .sobelEdgeDetection: return BBMetalSobelEdgeDetectionFilter().filteredImage(with: image)
        case .bilateralBlur: return BBMetalBilateralBlurFilter().filteredImage(with: image)
        case .beauty: return BBMetalBeautyFilter().filteredImage(with: image)
        }
    }
    
    private func topBlendImage(withAlpha alpha: Float) -> UIImage {
        let image = UIImage(named: "multicolour_flowers.jpg")!
        if alpha == 1 { return image }
        return BBMetalRGBAFilter(alpha: alpha).filteredImage(with: image)!
    }
}
