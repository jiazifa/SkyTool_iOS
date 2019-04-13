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
    
    var tasks: [MissionTaskType] = []
    
    init(sourceController: UIViewController) {
        self.viewController = sourceController
        self.preapreTasks()
    }
    
    @objc(addButtonClicked:)
    func onAddClicked(_ sender: UIControl) {

    }
}

extension HomeController {
    func preapreTasks() {
        if let url = URL(string: "https://opensheetmusicdisplay.github.io/demo/") {
            let task = WebControllerTask.init("openSheet", url: url, isExternal: true)
            self.tasks.append(task)
        }
    }
}
