//
//  MainMenuVC.swift
//  BBMetalImageDemo
//
//  Created by Kaibo Lu on 4/1/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

typealias NoParamterBlock = () -> Void

class MainMenuVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var list: [(String, NoParamterBlock)]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let staticImageFilter = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(StaticImageFilterMenuVC(), animated: true) }
        }
        let cameraFilter = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraFilterMenuVC(), animated: true) }
        }
        let cameraPhotoFilter = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraPhotoFilterVC(), animated: true) }
        }
        let videoFilter = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(VideoFilterVC(), animated: true) }
        }
        let videoFilter2 = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(VideoFilterVC2(), animated: true) }
        }
        let cameraVideoBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(CameraVideoBlendVC(), animated: true) }
        }
        let multipleImageBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(MultipleImageBlendVC(), animated: true) }
        }
        let multipleVideoBlend = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(MultipleVideoBlendVC(), animated: true) }
        }
        let recordUI = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(RecordUIVC(), animated: true) }
        }
        list = [("Static image filter", staticImageFilter),
                ("Camera filter", cameraFilter),
                ("Camera photo filter", cameraPhotoFilter),
                ("Video filter", videoFilter),
                ("Video filter 2", videoFilter2),
                ("Camera video blend", cameraVideoBlend),
                ("Multiple image blend", multipleImageBlend),
                ("Multiple video blend", multipleVideoBlend),
                ("Record UI", recordUI)]
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension MainMenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
        cell.textLabel?.text = list[indexPath.row].0
        return cell
    }
}

extension MainMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        list[indexPath.row].1()
    }
}
