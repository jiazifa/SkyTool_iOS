//
//  HomeController.swift
//  SkyTool
//
//  Created by tree on 2019/3/21.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit
import AVFoundation

class HomeController: ViewControllerCooridinatorType {
    
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
        let vm = AddMissionViewModel.init()
        let addViewController = AddMissionViewController.init(viewModel: vm)
        pushViewController(from: viewController, to: addViewController)
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
