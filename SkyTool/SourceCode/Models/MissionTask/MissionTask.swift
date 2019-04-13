//
//  MissionTask.swift
//  SkyTool
//
//  Created by tree on 2019/4/11.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import UIKit

class WebControllerTask: MissionTaskType {
    var type: MissionType
    
    var delegate: CommandDelegate?
    
    var name: String
    
    var identifier: UUID = UUID()
    
    var viewController: UIViewController?
    
    var url: URL
    
    init(_ name: String, url: URL, isExternal: Bool) {
        self.name = name
        self.url = url
        self.type = isExternal ? .externalWeb : .internalWeb
    }
    
    func execute() {
        defer { CommandManager.shared.done(self) }
        switch self.type {
        case .internalWeb:
            guard let sourceViewController = self.viewController else { return }
            let webViewController = WebViewController(self.url)
            sourceViewController.navigationController?.pushViewController(webViewController, animated: true)
        case .externalWeb:
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        default:
            fatalError()
        }
    }
}

class ViewControllerTask: MissionTaskType {
    var type: MissionType
    
    var delegate: CommandDelegate?
    
    var name: String
    
    var identifier: UUID = UUID()
    
    var viewController: UIViewController?
    
    init(_ name: String, targetController: UIViewController) {
        self.name = name
        self.type = .viewController(targetController)
    }
    
    func execute() {
        defer { CommandManager.shared.done(self) }
        switch self.type {
        case .viewController(let target):
            guard let current = self.viewController else { return }
            target.title = self.name
            current.navigationController?.pushViewController(target, animated: true)
        default:
            fatalError()
        }
    }
}
