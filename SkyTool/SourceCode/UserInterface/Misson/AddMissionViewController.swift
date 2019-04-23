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
    
    lazy var exisitsTypes: [MissionType] = {
        return TaskStore.shared.load().map({$0.type})
    }()
    
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
        guard self.exisitsTypes.contains(mission) == false else {
            return
        }
        switch mission {
        case .rss:
            let mis = MissionBaseTask.init(name: "Rss", type: .rss)
            TaskStore.shared.add(mis)
            self.exisitsTypes = TaskStore.shared.load().map({$0.type})
        default: break
        }
    }
    
}
