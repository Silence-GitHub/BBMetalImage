//
//  StaticImageFilterMenuVC.swift
//  BBMetalImageDemo
//
//  Created by Kaibo Lu on 4/2/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

class StaticImageFilterMenuVC: UIViewController {
    private var list: [(String, NoParamterBlock)]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Static image"
        view.backgroundColor = .gray
        
        let brightness = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .brightness), animated: true) }
        }
        let exposure = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .exposure), animated: true) }
        }
        let contrast = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .contrast), animated: true) }
        }
        let saturation = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .saturation), animated: true) }
        }
        let gamma = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .gamma), animated: true) }
        }
        let levels = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .levels), animated: true) }
        }
        let colorMatrix = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .colorMatrix), animated: true) }
        }
        let rgba = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .rgba), animated: true) }
        }
        let hue = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .hue), animated: true) }
        }
        let vibrance = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .vibrance), animated: true) }
        }
        let whiteBalance = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .whiteBalance), animated: true) }
        }
        let highlightShadow = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .highlightShadow), animated: true) }
        }
        let highlightShadowTint = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .highlightShadowTint), animated: true) }
        }
        let lookup = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .lookup), animated: true) }
        }
        let colorInversion = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .colorInversion), animated: true) }
        }
        let monochrome = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .monochrome), animated: true) }
        }
        let falseColor = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .falseColor), animated: true) }
        }
        let haze = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .haze), animated: true) }
        }
        let luminance = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .luminance), animated: true) }
        }
        let luminanceThreshold = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .luminanceThreshold), animated: true) }
        }
        let erosion = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .erosion), animated: true) }
        }
        let rgbaErosion = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .rgbaErosion), animated: true) }
        }
        let dilation = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .dilation), animated: true) }
        }
        let rgbaDilation = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .rgbaDilation), animated: true) }
        }
        let chromaKey = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .chromaKey), animated: true) }
        }
        let crop = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .crop), animated: true) }
        }
        let resize = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .resize), animated: true) }
        }
        let rotate = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .rotate), animated: true) }
        }
        let flip = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .flip), animated: true) }
        }
        let transform = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .transform), animated: true) }
        }
        let sharpen = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .sharpen), animated: true) }
        }
        let unsharpMask = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .unsharpMask), animated: true) }
        }
        let gaussianBlur = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .gaussianBlur), animated: true) }
        }
        let boxBlur = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .boxBlur), animated: true) }
        }
        let zoomBlur = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .zoomBlur), animated: true) }
        }
        let motionBlur = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .motionBlur), animated: true) }
        }
        let tiltShift = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .tiltShift), animated: true) }
        }
        let normalBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .normalBlend), animated: true) }
        }
        let chromaKeyBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .chromaKeyBlend), animated: true) }
        }
        let dissolveBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .dissolveBlend), animated: true) }
        }
        let addBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .addBlend), animated: true) }
        }
        let subtractBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .subtractBlend), animated: true) }
        }
        let multiplyBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .multiplyBlend), animated: true) }
        }
        let divideBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .divideBlend), animated: true) }
        }
        let overlayBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .overlayBlend), animated: true) }
        }
        let darkenBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .darkenBlend), animated: true) }
        }
        let lightenBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .lightenBlend), animated: true) }
        }
        let colorBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .colorBlend), animated: true) }
        }
        let colorBurnBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .colorBurnBlend), animated: true) }
        }
        let colorDodgeBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .colorDodgeBlend), animated: true) }
        }
        let screenBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .screenBlend), animated: true) }
        }
        let exclusionBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .exclusionBlend), animated: true) }
        }
        let differenceBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .differenceBlend), animated: true) }
        }
        let hardLightBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .hardLightBlend), animated: true) }
        }
        let softLightBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .softLightBlend), animated: true) }
        }
        let alphaBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .alphaBlend), animated: true) }
        }
        let sourceOverBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .sourceOverBlend), animated: true) }
        }
        let hueBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .hueBlend), animated: true) }
        }
        let saturationBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .saturationBlend), animated: true) }
        }
        let luminosityBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .luminosityBlend), animated: true) }
        }
        let linearBurnBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .linearBurnBlend), animated: true) }
        }
        let maskBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .maskBlend), animated: true) }
        }
        let pixellate = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .pixellate), animated: true) }
        }
        let polarPixellate = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .polarPixellate), animated: true) }
        }
        let polkaDot = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .polkaDot), animated: true) }
        }
        let halftone = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .halftone), animated: true) }
        }
        let crosshatch = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .crosshatch), animated: true) }
        }
        let sketch = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .sketch), animated: true) }
        }
        let thresholdSketch = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .thresholdSketch), animated: true) }
        }
        let toon = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .toon), animated: true) }
        }
        let posterize = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .posterize), animated: true) }
        }
        let vignette = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .vignette), animated: true) }
        }
        let kuwahara = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .kuwahara), animated: true) }
        }
        let swirl = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .swirl), animated: true) }
        }
        let bulge = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .bulge), animated: true) }
        }
        let pinch = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .pinch), animated: true) }
        }
        let convolution3x3 = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .convolution3x3), animated: true) }
        }
        let emboss = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .emboss), animated: true) }
        }
        let sobelEdgeDetection = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .sobelEdgeDetection), animated: true) }
        }
        let bilateralBlur = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .bilateralBlur), animated: true) }
        }
        let beauty = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .beauty), animated: true) }
        }
        list = [("Brightness", brightness),
                ("Exposure", exposure),
                ("Contrast", contrast),
                ("Saturation", saturation),
                ("Gamma", gamma),
                ("Levels", levels),
                ("Color matrix", colorMatrix),
                ("RGBA", rgba),
                ("Hue", hue),
                ("Vibrance", vibrance),
                ("White balance", whiteBalance),
                ("Highlight shadow", highlightShadow),
                ("Highlight shadow tint", highlightShadowTint),
                ("Lookup", lookup),
                ("Color inversion", colorInversion),
                ("Monochrome", monochrome),
                ("False color", falseColor),
                ("Haze", haze),
                ("Luminance", luminance),
                ("Luminance threshold", luminanceThreshold),
                ("Erosion", erosion),
                ("RGBAErosion", rgbaErosion),
                ("Dilation", dilation),
                ("RGBADilation", rgbaDilation),
                ("Chroma key", chromaKey),
                ("Crop", crop),
                ("Resize", resize),
                ("Rotate", rotate),
                ("Flip", flip),
                ("Transform", transform),
                ("Sharpen", sharpen),
                ("Unsharp mask", unsharpMask),
                ("Gaussian blur", gaussianBlur),
                ("Box blur", boxBlur),
                ("Zoom blur", zoomBlur),
                ("Motion blur", motionBlur),
                ("Tilt shift", tiltShift),
                ("Normal blend", normalBlend),
                ("Chroma key blend", chromaKeyBlend),
                ("Dissolve blend", dissolveBlend),
                ("Add blend", addBlend),
                ("Subtract blend", subtractBlend),
                ("Multiply blend", multiplyBlend),
                ("Divide blend", divideBlend),
                ("Overlay blend", overlayBlend),
                ("Darken blend", darkenBlend),
                ("Lighten blend", lightenBlend),
                ("Color blend", colorBlend),
                ("Color burn blend", colorBurnBlend),
                ("Color dodge blend", colorDodgeBlend),
                ("Screen blend", screenBlend),
                ("Exclusion blend", exclusionBlend),
                ("Difference blend", differenceBlend),
                ("Hard light blend", hardLightBlend),
                ("Soft light blend", softLightBlend),
                ("Alpha blend", alphaBlend),
                ("Source over blend", sourceOverBlend),
                ("Hue blend", hueBlend),
                ("Saturation blend", saturationBlend),
                ("Luminosity blend", luminosityBlend),
                ("Linear burn blend", linearBurnBlend),
                ("Mask blend", maskBlend),
                ("Pixellate", pixellate),
                ("Polar pixellate", polarPixellate),
                ("Polka dot", polkaDot),
                ("Halftone", halftone),
                ("Crosshatch", crosshatch),
                ("Sketch", sketch),
                ("Threshold sketch", thresholdSketch),
                ("Toon", toon),
                ("Posterize", posterize),
                ("Vignette", vignette),
                ("Kuwahara", kuwahara),
                ("Swirl", swirl),
                ("Bulge", bulge),
                ("Pinch", pinch),
                ("Convolution3x3", convolution3x3),
                ("Emboss", emboss),
                ("SobelEdgeDetection", sobelEdgeDetection),
                ("BilateralBlur", bilateralBlur),
                ("Beauty", beauty)]
        
        let tableView = UITableView(frame: view.bounds)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
}

extension StaticImageFilterMenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
        cell.textLabel?.text = list[indexPath.row].0
        return cell
    }
}

extension StaticImageFilterMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        list[indexPath.row].1()
    }
}
