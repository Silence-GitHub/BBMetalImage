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
    
    public func bb_saturationFiltered(withSaturation saturation: Float = 1) -> UIImage? {
        return filtered(with: BBMetalSaturationFilter(saturation: saturation))
    }
    
    public func bb_gammaFiltered(withGamma gamma: Float = 1) -> UIImage? {
        return filtered(with: BBMetalGammaFilter(gamma: gamma))
    }
    
    public func bb_levelsFiltered(withMinimum minimum: BBMetalColor = .black,
                                  middle: BBMetalColor = .white,
                                  maximum: BBMetalColor = .white,
                                  minOutput: BBMetalColor = .black,
                                  maxOutput: BBMetalColor = .white) -> UIImage? {
        
        return filtered(with: BBMetalLevelsFilter(minimum: minimum,
                                                  middle: middle,
                                                  maximum: maximum,
                                                  minOutput: minOutput,
                                                  maxOutput: maxOutput))
    }
    
    public func bb_colorMatrixFiltered(withColorMatrix colorMatrix: BBMetalMatrix4x4 = .identity, intensity: Float = 1) -> UIImage? {
        return filtered(with: BBMetalColorMatrixFilter(colorMatrix: colorMatrix, intensity: intensity))
    }
    
    public func bb_rgbaFiltered(withRed red: Float = 1, green: Float = 1, blue: Float = 1, alpha: Float = 1) -> UIImage? {
        return filtered(with: BBMetalRGBAFilter(red: red, green: green, blue: blue, alpha: alpha))
    }
    
    public func bb_hueFiltered(withHue hue: Float = 0) -> UIImage? {
        return filtered(with: BBMetalHueFilter(hue: hue))
    }
    
    public func bb_vibranceFiltered(withVibrance vibrance: Float = 0) -> UIImage? {
        return filtered(with: BBMetalVibranceFilter(vibrance: vibrance))
    }
    
    public func bb_whiteBalanceFiltered(withTemperature temperature: Float = 5000, tint: Float = 0) -> UIImage? {
        return filtered(with: BBMetalWhiteBalanceFilter(temperature: temperature, tint: tint))
    }
    
    public func bb_highlightShadowFiltered(withShadows shadows: Float = 0, highlights: Float = 1) -> UIImage? {
        return filtered(with: BBMetalHighlightShadowFilter(shadows: shadows, highlights: highlights))
    }
    
    public func bb_HighlightShadowTintFiltered(withShadowTintColor shadowTintColor: BBMetalColor = .red,
                                               shadowTintIntensity: Float = 0,
                                               highlightTintColor: BBMetalColor = .blue,
                                               highlightTintIntensity: Float = 0) -> UIImage? {
        
        return filtered(with: BBMetalHighlightShadowTintFilter(shadowTintColor: shadowTintColor,
                                                               shadowTintIntensity: shadowTintIntensity,
                                                               highlightTintColor: highlightTintColor,
                                                               highlightTintIntensity: highlightTintIntensity))
    }
    
    public func bb_lookupFiltered(withLookupTable lookupTable: MTLTexture, intensity: Float = 1) -> UIImage? {
        return filtered(with: BBMetalLookupFilter(lookupTable: lookupTable, intensity: intensity))
    }
    
    public func bb_colorInversionFiltered() -> UIImage? {
        return filtered(with: BBMetalColorInversionFilter())
    }
    
    public func bb_monochromeFiltered(withColor color: BBMetalColor = .red, intensity: Float = 0) -> UIImage? {
        return filtered(with: BBMetalMonochromeFilter(color: color, intensity: intensity))
    }
    
    public func bb_falseColorFiltered(withFirstColor firstColor: BBMetalColor = .red, secondColor: BBMetalColor = .blue) -> UIImage? {
        return filtered(with: BBMetalFalseColorFilter(firstColor: firstColor, secondColor: secondColor))
    }
    
    public func bb_hazeFiltered(withDistance distance: Float = 0, slope: Float = 0) -> UIImage? {
        return filtered(with: BBMetalHazeFilter(distance: distance, slope: slope))
    }
    
    public func bb_luminanceFiltered() -> UIImage? {
        return filtered(with: BBMetalLuminanceFilter())
    }
    
    public func bb_luminanceThresholdFiltered(withThreshold threshold: Float = 0.5) -> UIImage? {
        return filtered(with: BBMetalLuminanceThresholdFilter(threshold: threshold))
    }
    
    public func bb_chromaKeyFiltered(withThresholdSensitivity thresholdSensitivity: Float = 0.4, smoothing: Float = 0.1, colorToReplace: BBMetalColor = .green) -> UIImage? {
        return filtered(with: BBMetalChromaKeyFilter(thresholdSensitivity: thresholdSensitivity, smoothing: smoothing, colorToReplace: colorToReplace))
    }
    
    public func bb_sharpenFiltered(withSharpeness sharpeness: Float = 0) -> UIImage? {
        return filtered(with: BBMetalSharpenFilter(sharpeness: sharpeness))
    }
    
    public func bb_unsharpMaskFiltered(withSigma sigma: Float = 4, intensity: Float = 1) -> UIImage? {
        return filtered(with: BBMetalUnsharpMaskFilter(sigma: sigma, intensity: intensity))
    }
    
    public func bb_gaussianBlurFiltered(withSigma sigma: Float) -> UIImage? {
        return filtered(with: BBMetalGaussianBlurFilter(sigma: sigma))
    }
    
    public func bb_boxBlurFiltered(withKernelWidth kernelWidth: Int = 1, kernelHeight: Int = 1) -> UIImage? {
        return filtered(with: BBMetalBoxBlurFilter(kernelWidth: kernelWidth, kernelHeight: kernelHeight))
    }
    
    public func bb_zoomBlurFiltered(withBlurSize blurSize: Float = 0, blurCenter: BBMetalPosition = .center) -> UIImage? {
        return filtered(with: BBMetalZoomBlurFilter(blurSize: blurSize, blurCenter: blurCenter))
    }
    
    public func bb_motionBlurFiltered(withBlurSize blurSize: Float = 0, blurAngle: Float = 0) -> UIImage? {
        return filtered(with: BBMetalMotionBlurFilter(blurSize: blurSize, blurAngle: blurAngle))
    }
    
    public func bb_normalBlendFiltered(withImage image: UIImage) -> UIImage? {
        return filtered(with: BBMetalNormalBlendFilter(), image: image)
    }
    
    public func bb_chromaKeyBlendFiltered(withThresholdSensitivity thresholdSensitivity: Float = 0.4,
                                          smoothing: Float = 0.1,
                                          colorToReplace: BBMetalColor = .green,
                                          image: UIImage) -> UIImage? {
        
        return filtered(with: BBMetalChromaKeyBlendFilter(thresholdSensitivity: thresholdSensitivity,
                                                          smoothing: smoothing,
                                                          colorToReplace: colorToReplace),
                        image: image)
    }
    
    public func bb_dissolveBlendFiltered(withMixturePercent mixturePercent: Float = 0, image: UIImage) -> UIImage? {
        return filtered(with: BBMetalDissolveBlendFilter(mixturePercent: mixturePercent), image: image)
    }
    
    public func bb_addBlendFiltered(withImage image: UIImage) -> UIImage? {
        return filtered(with: BBMetalAddBlendFilter(), image: image)
    }
    
    public func bb_subtractBlendFiltered(withImage image: UIImage) -> UIImage? {
        return filtered(with: BBMetalSubtractBlendFilter(), image: image)
    }
    
    public func bb_multiplyBlendFiltered(withImage image: UIImage) -> UIImage? {
        return filtered(with: BBMetalMultiplyBlendFilter(), image: image)
    }
    
    public func bb_divideBlendFiltered(withImage image: UIImage) -> UIImage? {
        return filtered(with: BBMetalDivideBlendFilter(), image: image)
    }
    
    public func bb_overlayBlendFiltered(withImage image: UIImage) -> UIImage? {
        return filtered(with: BBMetalOverlayBlendFilter(), image: image)
    }
    
    public func bb_darkenBlendFiltered(withImage image: UIImage) -> UIImage? {
        return filtered(with: BBMetalDarkenBlendFilter(), image: image)
    }
    
    public func bb_lightenBlendFiltered(withImage image: UIImage) -> UIImage? {
        return filtered(with: BBMetalLightenBlendFilter(), image: image)
    }
    
    public func bb_colorBlendFiltered(withImage image: UIImage) -> UIImage? {
        return filtered(with: BBMetalColorBlendFilter(), image: image)
    }
    
    public func bb_colorBurnBlendFiltered(withImage image: UIImage) -> UIImage? {
        return filtered(with: BBMetalColorBurnBlendFilter(), image: image)
    }
    
    public func bb_colorDodgeBlendFiltered(withImage image: UIImage) -> UIImage? {
        return filtered(with: BBMetalColorDodgeBlendFilter(), image: image)
    }
    
    public func bb_screenBlendFiltered(withImage image: UIImage) -> UIImage? {
        return filtered(with: BBMetalScreenBlendFilter(), image: image)
    }
    
    public func bb_exclusionBlendFiltered(withImage image: UIImage) -> UIImage? {
        return filtered(with: BBMetalExclusionBlendFilter(), image: image)
    }
    
    public func bb_differenceBlendFiltered(withImage image: UIImage) -> UIImage? {
        return filtered(with: BBMetalDifferenceBlendFilter(), image: image)
    }
    
    public func bb_hardLightBlendFiltered(withImage image: UIImage) -> UIImage? {
        return filtered(with: BBMetalHardLightBlendFilter(), image: image)
    }
    
    public func bb_softLightBlendFiltered(withImage image: UIImage) -> UIImage? {
        return filtered(with: BBMetalSoftLightBlendFilter(), image: image)
    }
    
    public func bb_alphaBlendFiltered(withMixturePercent mixturePercent: Float = 0, image: UIImage) -> UIImage? {
        return filtered(with: BBMetalAlphaBlendFilter(mixturePercent: mixturePercent), image: image)
    }
    
    public func bb_sourceOverBlendFiltered(withImage image: UIImage) -> UIImage? {
        return filtered(with: BBMetalSourceOverBlendFilter(), image: image)
    }
    
    public func bb_hueBlendFiltered(withImage image: UIImage) -> UIImage? {
        return filtered(with: BBMetalHueBlendFilter(), image: image)
    }
    
    public func bb_saturationBlendFiltered(withImage image: UIImage) -> UIImage? {
        return filtered(with: BBMetalSaturationBlendFilter(), image: image)
    }
    
    public func bb_luminosityBlendFiltered(withImage image: UIImage) -> UIImage? {
        return filtered(with: BBMetalLuminosityBlendFilter(), image: image)
    }
    
    public func bb_linearBurnBlendFiltered(withImage image: UIImage) -> UIImage? {
        return filtered(with: BBMetalLinearBurnBlendFilter(), image: image)
    }
    
    public func bb_maskBlendFiltered(withImage image: UIImage) -> UIImage? {
        return filtered(with: BBMetalMaskBlendFilter(), image: image)
    }
    
    public func bb_pixellateFiltered(withFractionalWidth fractionalWidth: Float = 0.05) -> UIImage? {
        return filtered(with: BBMetalPixellateFilter(fractionalWidth: fractionalWidth))
    }
    
    public func bb_polarPixellateFiltered(withPixelSize pixelSize: BBMetalSize = BBMetalSize(width: 0.05, height: 0.05), center: BBMetalPosition = .center) -> UIImage? {
        return filtered(with: BBMetalPolarPixellateFilter(pixelSize: pixelSize, center: center))
    }
    
    public func bb_polkaDotFiltered(withFractionalWidth fractionalWidth: Float = 0.05, dotScaling: Float = 0.9) -> UIImage? {
        return filtered(with: BBMetalPolkaDotFilter(fractionalWidth: fractionalWidth, dotScaling: dotScaling))
    }
    
    public func bb_halftoneFiltered(withFractionalWidth fractionalWidth: Float = 0.01) -> UIImage? {
        return filtered(with: BBMetalHalftoneFilter(fractionalWidth: fractionalWidth))
    }
    
    public func bb_crosshatchFiltered(withCrosshatchSpacing crosshatchSpacing: Float = 0.03, lineWidth: Float = 0.003) -> UIImage? {
        return filtered(with: BBMetalCrosshatchFilter(crosshatchSpacing: crosshatchSpacing, lineWidth: lineWidth))
    }
    
    public func bb_sketchFiltered(withEdgeStrength edgeStrength: Float = 1) -> UIImage? {
        return filtered(with: BBMetalSketchFilter(edgeStrength: edgeStrength))
    }
    
    public func bb_thresholdSketchFiltered(withEdgeStrength edgeStrength: Float = 1, threshold: Float = 0.25) -> UIImage? {
        return filtered(with: BBMetalThresholdSketchFilter(edgeStrength: edgeStrength, threshold: threshold))
    }
    
    public func bb_toonFiltered(withThreshold threshold: Float = 0.2, quantizationLevels: Float = 10) -> UIImage? {
        return filtered(with: BBMetalToonFilter(threshold: threshold, quantizationLevels: quantizationLevels))
    }
    
    public func bb_posterizeFiltered(withColorLevels colorLevels: Float = 10) -> UIImage? {
        return filtered(with: BBMetalPosterizeFilter(colorLevels: colorLevels))
    }
    
    public func bb_swirlFiltered(withCenter center: BBMetalPosition = .center, radius: Float = 0.5, angle: Float = 1) -> UIImage? {
        return filtered(with: BBMetalSwirlFilter(center: center, radius: radius, angle: angle))
    }
    
    private func filtered(with filter: BBMetalBaseFilter, image: UIImage...) -> UIImage? {
        filter.runSynchronously = true
        let sources = ([self] + image).map { BBMetalStaticImageSource(image: $0) }
        for source in sources { source.add(consumer: filter) }
        for source in sources { source.transmitTexture() }
        return filter.outputTexture?.bb_image
    }
}
