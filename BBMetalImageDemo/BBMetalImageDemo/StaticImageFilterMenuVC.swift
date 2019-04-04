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
                ("Luminance", luminance)]
        
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
}
