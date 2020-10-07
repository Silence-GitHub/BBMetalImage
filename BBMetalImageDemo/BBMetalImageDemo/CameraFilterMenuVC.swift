//
//  CameraFilterMenuVC.swift
//  BBMetalImageDemo
//
//  Created by Kaibo Lu on 4/9/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

class CameraFilterMenuVC: UIViewController {
    private var list: [(String, NoParamterBlock)]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Camera"
        view.backgroundColor = .gray
        
        let brightness = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .brightness), animated: true) }
        }
        let exposure = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .exposure), animated: true) }
        }
        let contrast = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .contrast), animated: true) }
        }
        let saturation = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .saturation), animated: true) }
        }
        let gamma = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .gamma), animated: true) }
        }
        let levels = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .levels), animated: true) }
        }
        let colorMatrix = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .colorMatrix), animated: true) }
        }
        let rgba = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .rgba), animated: true) }
        }
        let hue = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .hue), animated: true) }
        }
        let vibrance = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .vibrance), animated: true) }
        }
        let whiteBalance = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .whiteBalance), animated: true) }
        }
        let highlightShadow = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .highlightShadow), animated: true) }
        }
        let highlightShadowTint = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .highlightShadowTint), animated: true) }
        }
        let lookup = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .lookup), animated: true) }
        }
        let colorInversion = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .colorInversion), animated: true) }
        }
        let monochrome = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .monochrome), animated: true) }
        }
        let falseColor = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .falseColor), animated: true) }
        }
        let haze = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .haze), animated: true) }
        }
        let luminance = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .luminance), animated: true) }
        }
        let luminanceThreshold = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .luminanceThreshold), animated: true) }
        }
        let erosion = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .erosion), animated: true) }
        }
        let rgbaErosion = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .rgbaErosion), animated: true) }
        }
        let dilation = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .dilation), animated: true) }
        }
        let rgbaDilation = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .rgbaDilation), animated: true) }
        }
        let chromaKey = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .chromaKey), animated: true) }
        }
        let crop = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .crop), animated: true) }
        }
        let resize = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .resize), animated: true) }
        }
        let rotate = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .rotate), animated: true) }
        }
        let flip = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .flip), animated: true) }
        }
        let transform = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .transform), animated: true) }
        }
        let sharpen = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .sharpen), animated: true) }
        }
        let unsharpMask = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .unsharpMask), animated: true) }
        }
        let gaussianBlur = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .gaussianBlur), animated: true) }
        }
        let boxBlur = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .boxBlur), animated: true) }
        }
        let zoomBlur = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .zoomBlur), animated: true) }
        }
        let motionBlur = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .motionBlur), animated: true) }
        }
        let tiltShift = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .tiltShift), animated: true) }
        }
        let normalBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .normalBlend), animated: true) }
        }
        let chromaKeyBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .chromaKeyBlend), animated: true) }
        }
        let dissolveBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .dissolveBlend), animated: true) }
        }
        let addBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .addBlend), animated: true) }
        }
        let subtractBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .subtractBlend), animated: true) }
        }
        let multiplyBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .multiplyBlend), animated: true) }
        }
        let divideBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .divideBlend), animated: true) }
        }
        let overlayBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .overlayBlend), animated: true) }
        }
        let darkenBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .darkenBlend), animated: true) }
        }
        let lightenBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .lightenBlend), animated: true) }
        }
        let colorBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .colorBlend), animated: true) }
        }
        let colorBurnBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .colorBurnBlend), animated: true) }
        }
        let colorDodgeBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .colorDodgeBlend), animated: true) }
        }
        let screenBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .screenBlend), animated: true) }
        }
        let exclusionBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .exclusionBlend), animated: true) }
        }
        let differenceBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .differenceBlend), animated: true) }
        }
        let hardLightBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .hardLightBlend), animated: true) }
        }
        let softLightBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .softLightBlend), animated: true) }
        }
        let alphaBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .alphaBlend), animated: true) }
        }
        let sourceOverBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .sourceOverBlend), animated: true) }
        }
        let hueBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .hueBlend), animated: true) }
        }
        let saturationBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .saturationBlend), animated: true) }
        }
        let luminosityBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .luminosityBlend), animated: true) }
        }
        let linearBurnBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .linearBurnBlend), animated: true) }
        }
        let maskBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .maskBlend), animated: true) }
        }
        let pixellate = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .pixellate), animated: true) }
        }
        let polarPixellate = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .polarPixellate), animated: true) }
        }
        let polkaDot = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .polkaDot), animated: true) }
        }
        let halftone = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .halftone), animated: true) }
        }
        let crosshatch = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .crosshatch), animated: true) }
        }
        let sketch = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .sketch), animated: true) }
        }
        let thresholdSketch = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .thresholdSketch), animated: true) }
        }
        let toon = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .toon), animated: true) }
        }
        let posterize = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .posterize), animated: true) }
        }
        let vignette = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .vignette), animated: true) }
        }
        let kuwahara = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .kuwahara), animated: true) }
        }
        let swirl = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .swirl), animated: true) }
        }
        let bulge = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .bulge), animated: true) }
        }
        let pinch = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .pinch), animated: true) }
        }
        let convolution3x3 = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .convolution3x3), animated: true) }
        }
        let emboss = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .emboss), animated: true) }
        }
        let sobelEdgeDetection = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .sobelEdgeDetection), animated: true) }
        }
        let bilateralBlur = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .bilateralBlur), animated: true) }
        }
        let beauty = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterVC(type: .beauty), animated: true) }
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

extension CameraFilterMenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
        cell.textLabel?.text = list[indexPath.row].0
        return cell
    }
}

extension CameraFilterMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        list[indexPath.row].1()
    }
}
