//
//  AddMissionViewController.swift
//  SkyTool
//
//  Created by tree on 2019/4/23.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import UIKit

class AddMissionViewController: UIViewController {
    let tableView: UITableView = UITableView.tableView()
    
    var allMission: [MissionType] = MissionType.all_types
    
    let coordinator: MissionCoordinator
    
    required init(coordinator: MissionCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.background
        self.createSubViews()
        self.createConstraints()
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    func createSubViews() {
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func createConstraints() {
        self.tableView.autoPinEdgesToSuperviewEdges()
    }
}

extension AddMissionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allMission.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
        let mission = self.allMission[indexPath.row]
        cell.textLabel?.text = "\(mission)"
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = UIColor.textBlack
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let mission = self.allMission[indexPath.row]
        self.coordinator.addMission(mission)
    }
    
}
