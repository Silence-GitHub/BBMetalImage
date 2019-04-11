//
//  CameraFilterVC.swift
//  BBMetalImageDemo
//
//  Created by Kaibo Lu on 4/8/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit
import BBMetalImage

class CameraFilterVC: UIViewController {
    private let type: FilterType
    private var camera: BBMetalCamera!
    private var metalView: BBMetalView!
    private var imageSource: BBMetalStaticImageSource?
    
    init(type: FilterType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "\(type)"
        view.backgroundColor = .gray
        
        metalView = BBMetalView(frame: CGRect(x: 10, y: 100, width: view.bounds.width - 20, height: view.bounds.height - 200),
                                device: BBMetalDevice.sharedDevice)
        view.addSubview(metalView)
        
        let button = UIButton(frame: CGRect(x: 10, y: view.bounds.height - 90, width: view.bounds.width - 20, height: 30))
        button.backgroundColor = .blue
        button.setTitle("Add filter", for: .normal)
        button.setTitle("Remove filer", for: .selected)
        button.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
        view.addSubview(button)
        
        camera = BBMetalCamera()
        camera.add(consumer: metalView)
        camera.start()
    }
    
    @objc private func clickButton(_ button: UIButton) {
        button.isSelected = !button.isSelected
        camera.removeAllConsumers()
        if button.isSelected, let filter = self.filter {
            camera.add(consumer: filter).add(consumer: metalView)
            if let source = imageSource {
                camera.willTransmitTexture = { [weak self] texture in
                    guard self != nil else { return }
                    source.transmitTexture()
                }
                source.add(consumer: filter)
            }
        } else {
            camera.add(consumer: metalView)
            camera.willTransmitTexture = nil
            imageSource = nil
        }
    }
    
    private var filter: BBMetalBaseFilter? {
        switch type {
        case .brightness: return BBMetalBrightnessFilter(brightness: 0.15)
        case .exposure: return BBMetalExposureFilter(exposure: 0.5)
        case .contrast: return BBMetalContrastFilter(contrast: 1.5)
        case .saturation: return BBMetalSaturationFilter(saturation: 2)
        case .gamma: return BBMetalGammaFilter(gamma: 1.5)
        case .levels: return BBMetalLevelsFilter(minimum: .red)
        case .colorMatrix:
            var matrix: BBMetalMatrix4x4 = .identity
            matrix.m12 = 1
            matrix.m32 = 1
            matrix.m42 = 1
            return BBMetalColorMatrixFilter(colorMatrix: matrix, intensity: 1)
        case .rgba: return BBMetalRGBAFilter(red: 1.2, green: 1, blue: 1, alpha: 1)
        case .hue: return BBMetalHueFilter(hue: 90)
        case .vibrance: return BBMetalVibranceFilter(vibrance: 1)
        case .whiteBalance: return BBMetalWhiteBalanceFilter(temperature: 7000, tint: 0)
        case .highlightShadow: return BBMetalHighlightShadowFilter(shadows: 0.5, highlights: 0.5)
        case .highlightShadowTint: return BBMetalHighlightShadowTintFilter(shadowTintColor: .blue,
                                                                           shadowTintIntensity: 0.5,
                                                                           highlightTintColor: .red,
                                                                           highlightTintIntensity: 0.5)
        case .lookup:
            let url = Bundle.main.url(forResource: "test_lookup", withExtension: "png")!
            let data = try! Data(contentsOf: url)
            return BBMetalLookupFilter(lookupTable: data.bb_metalTexture!, intensity: 1)
        case .colorInversion: return BBMetalColorInversionFilter()
        case .monochrome: return BBMetalMonochromeFilter(color: BBMetalColor(red: 0.7, green: 0.6, blue: 0.5), intensity: 1)
        case .falseColor: return BBMetalFalseColorFilter(firstColor: .red, secondColor: .blue)
        case .haze: return BBMetalHazeFilter(distance: 0.2, slope: 0)
        case .luminance: return BBMetalLuminanceFilter()
        case .luminanceThreshold: return BBMetalLuminanceThresholdFilter(threshold: 0.6)
        case .chromaKey: return BBMetalChromaKeyFilter(thresholdSensitivity: 0.4, smoothing: 0.1, colorToReplace: .blue)
        case .sharpen: return BBMetalSharpenFilter(sharpeness: 0.5)
        case .gaussianBlur: return BBMetalGaussianBlurFilter(sigma: 3)
        case .boxBlur: return BBMetalBoxBlurFilter(kernelWidth: 25, kernelHeight: 65)
        case .zoomBlur: return BBMetalZoomBlurFilter(blurSize: 3, blurCenter: BBMetalPosition(x: 0.35, y: 0.55))
        case .motionBlur: return BBMetalMotionBlurFilter(blurSize: 5, blurAngle: 30)
        case .normalBlend:
            imageSource = BBMetalStaticImageSource(image: topBlendImage(withAlpha: 0.1))
            return BBMetalNormalBlendFilter()
        case .chromaKeyBlend:
            imageSource = BBMetalStaticImageSource(image: topBlendImage(withAlpha: 0.1))
            return BBMetalChromaKeyBlendFilter(thresholdSensitivity: 0.4, smoothing: 0.1, colorToReplace: .blue)
        case .dissolveBlend:
            imageSource = BBMetalStaticImageSource(image: topBlendImage(withAlpha: 0.1))
            return BBMetalDissolveBlendFilter(mixturePercent: 0.3)
        case .addBlend:
            imageSource = BBMetalStaticImageSource(image: topBlendImage(withAlpha: 0.5))
            return BBMetalAddBlendFilter()
        case .subtractBlend:
            imageSource = BBMetalStaticImageSource(image: topBlendImage(withAlpha: 0.1))
            return BBMetalSubtractBlendFilter()
        case .multiplyBlend:
            imageSource = BBMetalStaticImageSource(image: topBlendImage(withAlpha: 0.1))
            return BBMetalMultiplyBlendFilter()
        case .divideBlend:
            imageSource = BBMetalStaticImageSource(image: topBlendImage(withAlpha: 0.5))
            return BBMetalDivideBlendFilter()
        case .overlayBlend:
            imageSource = BBMetalStaticImageSource(image: topBlendImage(withAlpha: 0.1))
            return BBMetalOverlayBlendFilter()
        case .darkenBlend:
            imageSource = BBMetalStaticImageSource(image: topBlendImage(withAlpha: 0.5))
            return BBMetalDarkenBlendFilter()
        case .lightenBlend:
            imageSource = BBMetalStaticImageSource(image: topBlendImage(withAlpha: 0.1))
            return BBMetalLightenBlendFilter()
        case .colorBlend:
            imageSource = BBMetalStaticImageSource(image: topBlendImage(withAlpha: 1))
            return BBMetalColorBlendFilter()
        case .colorBurnBlend:
            imageSource = BBMetalStaticImageSource(image: topBlendImage(withAlpha: 0.1))
            return BBMetalColorBurnBlendFilter()
        case .colorDodgeBlend:
            imageSource = BBMetalStaticImageSource(image: topBlendImage(withAlpha: 0.5))
            return BBMetalColorDodgeBlendFilter()
        case .screenBlend:
            imageSource = BBMetalStaticImageSource(image: topBlendImage(withAlpha: 0.1))
            return BBMetalScreenBlendFilter()
        case .exclusionBlend:
            imageSource = BBMetalStaticImageSource(image: topBlendImage(withAlpha: 0.1))
            return BBMetalExclusionBlendFilter()
        case .differenceBlend:
            imageSource = BBMetalStaticImageSource(image: topBlendImage(withAlpha: 0.1))
            return BBMetalDifferenceBlendFilter()
        case .hardLightBlend:
            imageSource = BBMetalStaticImageSource(image: topBlendImage(withAlpha: 0.1))
            return BBMetalHardLightBlendFilter()
        case .softLightBlend:
            imageSource = BBMetalStaticImageSource(image: topBlendImage(withAlpha: 0.1))
            return BBMetalSoftLightBlendFilter()
        case .alphaBlend:
            imageSource = BBMetalStaticImageSource(image: topBlendImage(withAlpha: 0.5))
            return BBMetalAlphaBlendFilter(mixturePercent: 0.5)
        case .sourceOverBlend:
            imageSource = BBMetalStaticImageSource(image: topBlendImage(withAlpha: 0.5))
            return BBMetalSourceOverBlendFilter()
        case .hueBlend:
            imageSource = BBMetalStaticImageSource(image: topBlendImage(withAlpha: 1))
            return BBMetalHueBlendFilter()
        case .saturationBlend:
            imageSource = BBMetalStaticImageSource(image: topBlendImage(withAlpha: 1))
            return BBMetalSaturationBlendFilter()
        case .luminosityBlend:
            imageSource = BBMetalStaticImageSource(image: topBlendImage(withAlpha: 0.5))
            return BBMetalLuminosityBlendFilter()
        case .linearBurnBlend:
            imageSource = BBMetalStaticImageSource(image: topBlendImage(withAlpha: 0.1))
            return BBMetalLinearBurnBlendFilter()
        case .maskBlend:
            imageSource = BBMetalStaticImageSource(image: topBlendImage(withAlpha: 1))
            return BBMetalMaskBlendFilter()
        case .pixellate: return BBMetalPixellateFilter(fractionalWidth: 0.05)
        case .polarPixellate: return BBMetalPolarPixellateFilter(pixelSize: BBMetalSize(width: 0.05, height: 0.03), center: BBMetalPosition(x: 0.35, y: 0.55))
        case .polkaDot: return BBMetalPolkaDotFilter(fractionalWidth: 0.05, dotScaling: 0.9)
        }
    }
    
    private func topBlendImage(withAlpha alpha: Float) -> UIImage {
        return UIImage(named: "multicolour_flowers.jpg")!.bb_rgbaFiltered(alpha: alpha)!
    }
}
