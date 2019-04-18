//
//  TestCameraMenuVC.swift
//  CompareImageLib
//
//  Created by Kaibo Lu on 4/17/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

import UIKit

class TestCameraMenuVC: UIViewController {

    private var list: [(String, NoParamterBlock)]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Camera"
        
        let testBB = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(TestCameraVC(type: .BBMetalImage), animated: true) }
        }
        let testGPU = { [weak self] in
            if let self = self { self.navigationController?.pushViewController(TestCameraVC(type: .GPUImage), animated: true) }
        }
        list = [("BBMetalImage", testBB),
                ("GPUImage", testGPU)]
        
        let tableView = UITableView(frame: view.bounds)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
}

extension TestCameraMenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
        cell.textLabel?.text = list[indexPath.row].0
        return cell
    }
}

extension TestCameraMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        list[indexPath.row].1()
    }
}
