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
        let chromaKey = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .chromaKey), animated: true) }
        }
        let sharpen = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .sharpen), animated: true) }
        }
        let gaussianBlur = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .gaussianBlur), animated: true) }
        }
        let zoomBlur = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .zoomBlur), animated: true) }
        }
        let motionBlur = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .motionBlur), animated: true) }
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
        list = [("Brightness", brightness),
                ("Exposure", exposure),
                ("Contrast", contrast),
                ("Saturation", saturation),
                ("Gamma", gamma),
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
                ("Chroma key", chromaKey),
                ("Sharpen", sharpen),
                ("Gaussian blur", gaussianBlur),
                ("Zoom blur", zoomBlur),
                ("Motion blur", motionBlur),
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
                ("Color burn blend", colorBurnBlend),
                ("Color dodge blend", colorDodgeBlend),
                ("Screen blend", screenBlend),
                ("Exclusion blend", exclusionBlend),
                ("Difference blend", differenceBlend),
                ("Hard light blend", hardLightBlend)]
        
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

enum FilterType {
    case brightness
    case exposure
    case contrast
    case saturation
    case gamma
    case rgba
    case hue
    case vibrance
    case whiteBalance
    case highlightShadow
    case highlightShadowTint
    case lookup
    case colorInversion
    case monochrome
    case falseColor
    case haze
    case luminance
    case luminanceThreshold
    case chromaKey
    case sharpen
    case gaussianBlur
    case zoomBlur
    case motionBlur
    case normalBlend
    case chromaKeyBlend
    case dissolveBlend
    case addBlend
    case subtractBlend
    case multiplyBlend
    case divideBlend
    case overlayBlend
    case darkenBlend
    case lightenBlend
    case colorBurnBlend
    case colorDodgeBlend
    case screenBlend
    case exclusionBlend
    case differenceBlend
    case hardLightBlend
}
