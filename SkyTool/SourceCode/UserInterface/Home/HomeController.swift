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
        self.viewController.navigationController?.pushViewController(RecordViewController(), animated: true)
       return
//        self.viewController.navigationController?.pushViewController(AddMissionViewController(), animated: true)
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
