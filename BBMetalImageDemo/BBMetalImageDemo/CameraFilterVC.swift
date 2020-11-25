//
//  CameraFilterVC.swift
//  BBMetalImageDemo
//
//  Created by Kaibo Lu on 4/8/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit
import AVFoundation
import BBMetalImage

class CameraFilterVC: UIViewController {
    private let type: FilterType
    private var camera: BBMetalCamera!
    private var metalView: BBMetalView!
    private var imageSource: BBMetalStaticImageSource?
    private var videoWriter: BBMetalVideoWriter!
    private var filePath: String!
    
    private var playButton: UIButton!
    
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
        
        let x: CGFloat = 10
        let width: CGFloat = view.bounds.width - 20
        metalView = BBMetalView(frame: CGRect(x: x, y: 100, width: width, height: view.bounds.height - 230))
        view.addSubview(metalView)
        
        let tapMetalView = UITapGestureRecognizer(target: self, action: #selector(tapMetalView(_:)))
        metalView.addGestureRecognizer(tapMetalView)
        
        var y: CGFloat = metalView.frame.maxY + 10
        var i = 0
        func generateButton(title: String, selectedTitle: String? = nil) -> UIButton {
            let button = UIButton(frame: CGRect(x: x, y: y, width: width, height: 30))
            button.backgroundColor = (i % 2 == 0 ? .blue : .red)
            button.setTitle(title, for: .normal)
            button.setTitle(selectedTitle, for: .selected)
            self.view.addSubview(button)
            i += 1
            y += button.frame.height
            return button
        }
        
        let filterButton = generateButton(title: "Add filter", selectedTitle: "Remove filter")
        filterButton.addTarget(self, action: #selector(clickFilterButton(_:)), for: .touchUpInside)
        
        let recordButton = generateButton(title: "Start recording", selectedTitle: "Finish recording")
        recordButton.addTarget(self, action: #selector(clickRecordButton(_:)), for: .touchUpInside)
        
        playButton = generateButton(title: "Play")
        playButton.addTarget(self, action: #selector(clickPlayButton(_:)), for: .touchUpInside)
        
        filePath = NSTemporaryDirectory() + "test.mp4"
        let url = URL(fileURLWithPath: filePath)
        videoWriter = BBMetalVideoWriter(url: url, frameSize: BBMetalIntSize(width: 1080, height: 1920))
        
        camera = BBMetalCamera(sessionPreset: .hd1920x1080)
        camera.audioConsumer = videoWriter
        camera.add(consumer: metalView)
        camera.add(consumer: videoWriter)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        try? AVAudioSession.sharedInstance().setCategory(.record, mode: .videoRecording, options: [])
        try? AVAudioSession.sharedInstance().setActive(true, options: [])
        camera.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        camera.stop()
    }
    
    @objc private func tapMetalView(_ tap: UITapGestureRecognizer) {
        camera.switchCameraPosition()
    }
    
    @objc private func clickFilterButton(_ button: UIButton) {
        button.isSelected = !button.isSelected
        camera.removeAllConsumers()
        if button.isSelected, let filter = self.filter {
            camera.add(consumer: filter).add(consumer: metalView)
            filter.add(consumer: videoWriter)
            if let source = imageSource {
                camera.willTransmitTexture = { [weak self] _, _ in
                    guard self != nil else { return }
                    source.transmitTexture()
                }
                source.add(consumer: filter)
            }
        } else {
            camera.add(consumer: metalView)
            camera.willTransmitTexture = nil
            imageSource = nil
            camera.add(consumer: videoWriter)
        }
    }
    
    @objc private func clickRecordButton(_ button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            playButton.isHidden = true
            try? FileManager.default.removeItem(at: videoWriter.url)
            videoWriter.start()
        } else {
            videoWriter.finish { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.playButton.isHidden = false
                }
            }
        }
    }
    
    @objc private func clickPlayButton(_ button: UIButton) {
        if FileManager.default.fileExists(atPath: filePath) {
            navigationController?.pushViewController(VideoPlayerVC(url: videoWriter.url), animated: true)
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
            var matrix: matrix_float4x4 = .identity
            matrix[0][1] = 1
            matrix[2][1] = 1
            matrix[3][1] = 1
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
        case .erosion: return BBMetalErosionFilter(pixelRadius: 2)
        case .rgbaErosion: return BBMetalRGBAErosionFilter(pixelRadius: 2)
        case .dilation: return BBMetalDilationFilter(pixelRadius: 2)
        case .rgbaDilation: return BBMetalRGBADilationFilter(pixelRadius: 2)
        case .chromaKey: return BBMetalChromaKeyFilter(thresholdSensitivity: 0.4, smoothing: 0.1, colorToReplace: .blue)
        case .crop: return BBMetalCropFilter(rect: BBMetalRect(x: 0.25, y: 0.5, width: 0.5, height: 0.5))
        case .resize: return BBMetalResizeFilter(size: BBMetalSize(width: 0.5, height: 0.8))
        case .rotate: return BBMetalRotateFilter(angle: -120, fitSize: true)
        case .flip: return BBMetalFlipFilter(horizontal: true, vertical: true)
        case .transform:
            let transform = CGAffineTransform(translationX: 960, y: 0).rotated(by: .pi / 180 * 30)
            return BBMetalTransformFilter(transform: transform, fitSize: true)
        case .sharpen: return BBMetalSharpenFilter(sharpeness: 0.5)
        case .unsharpMask: return BBMetalUnsharpMaskFilter(sigma: 4, intensity: 4)
        case .gaussianBlur: return BBMetalGaussianBlurFilter(sigma: 3)
        case .boxBlur: return BBMetalBoxBlurFilter(kernelWidth: 25, kernelHeight: 65)
        case .zoomBlur: return BBMetalZoomBlurFilter(blurSize: 3, blurCenter: BBMetalPosition(x: 0.35, y: 0.55))
        case .motionBlur: return BBMetalMotionBlurFilter(blurSize: 5, blurAngle: 30)
        case .tiltShift: return BBMetalTiltShiftFilter()
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
        case .halftone: return BBMetalHalftoneFilter(fractionalWidth: 0.01)
        case .crosshatch: return BBMetalCrosshatchFilter(crosshatchSpacing: 0.01, lineWidth: 0.003)
        case .sketch: return BBMetalSketchFilter(edgeStrength: 1)
        case .thresholdSketch: return BBMetalThresholdSketchFilter(edgeStrength: 1, threshold: 0.15)
        case .toon: return BBMetalToonFilter(threshold: 0.2, quantizationLevels: 10)
        case .posterize: return BBMetalPosterizeFilter(colorLevels: 10)
        case .vignette: return BBMetalVignetteFilter()
        case .kuwahara: return BBMetalKuwaharaFilter()
        case .swirl: return BBMetalSwirlFilter(center: BBMetalPosition(x: 0.35, y: 0.55), radius: 0.25, angle: 1)
        case .bulge: return BBMetalBulgeFilter(center: BBMetalPosition(x: 0.35, y: 0.55))
        case .pinch: return BBMetalPinchFilter(center: BBMetalPosition(x: 0.35, y: 0.55))
        case .convolution3x3: return BBMetalConvolution3x3Filter(convolution: simd_float3x3(rows: [SIMD3<Float>(-1, 0, 1),
                                                                                                   SIMD3<Float>(-2, 0, 2),
                                                                                                   SIMD3<Float>(-1, 0, 1)]))
        case .emboss: return BBMetalEmbossFilter(intensity: 1)
        case .sobelEdgeDetection: return BBMetalSobelEdgeDetectionFilter()
        case .bilateralBlur: return BBMetalBilateralBlurFilter()
        case .beauty: return BBMetalBeautyFilter()
        }
    }
    
    private func topBlendImage(withAlpha alpha: Float) -> UIImage {
        let image = UIImage(named: "multicolour_flowers.jpg")!
        if alpha == 1 { return image }
        return BBMetalRGBAFilter(alpha: alpha).filteredImage(with: image)!
    }
}
