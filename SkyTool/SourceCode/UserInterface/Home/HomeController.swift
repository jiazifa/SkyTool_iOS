//
//  HomeController.swift
//  SkyTool
//
//  Created by tree on 2019/3/21.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit
import AVFoundation

class HomeController {
    
    let viewController: UIViewController
    
    let recorder = Recorder()
    
    let onReload = Delegate<Void, Void>()
    
    let onEdit = Delegate<Bool, Void>()
    
    private(set) var isEditing = false
    
    var tasks: [MissionBaseTask] = []
    
    init(sourceController: UIViewController) {
        self.viewController = sourceController
        self.preapreTasks()
    }
    
    @objc(addButtonClicked:)
    func onAddClicked(_ sender: UIControl) {
        let coordinator = MissionCoordinator()
        let targetViewController = AddMissionViewController.init(coordinator: coordinator)
        self.viewController.navigationController?.pushViewController(targetViewController, animated: true)
    }
    
    @objc func onToggleCollectionViewEdit() {
        guard self.tasks.isEmpty == false else {
            return
        }
        self.isEditing = !self.isEditing
        self.onEdit.call(self.isEditing)
    }
}

extension HomeController {
    func preapreTasks() {
        self.tasks = TaskStore.shared.load()
        self.onReload.call()
    }
}
