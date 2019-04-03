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
        let rgb = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .rgb), animated: true) }
        }
        let lookup = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .lookup), animated: true) }
        }
        let luminance = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterVC(type: .luminance), animated: true) }
        }
        list = [("Brightness", brightness),
                ("Exposure", exposure),
                ("Contrast", contrast),
                ("Saturation", saturation),
                ("Gamma", gamma),
                ("RGB", rgb),
                ("Lookup", lookup),
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
    case rgb
    case lookup
    case luminance
}
