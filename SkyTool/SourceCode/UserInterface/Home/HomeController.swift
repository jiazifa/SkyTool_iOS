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
    
    var tasks: [MissionBaseTask] = []
    
    init(sourceController: UIViewController) {
        self.viewController = sourceController
        self.preapreTasks()
    }
    
    @objc(addButtonClicked:)
    func onAddClicked(_ sender: UIControl) {
        let mission = MissionBaseTask(name: "Rss", type: .rss)
        TaskStore.shared.add(mission)
        self.preapreTasks()
        self.onReload.call()
    }
}

extension HomeController {
    func preapreTasks() {
        self.tasks = TaskStore.shared.load()
    }
}
