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
        let videoFilter = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(VideoFilterVC(), animated: true) }
        }
        list = [("Static image filter", staticImageFilter),
                ("Camera filter", cameraFilter),
                ("Video filter", videoFilter)]
        
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
