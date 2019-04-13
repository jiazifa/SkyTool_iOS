//
//  MissionTask.swift
//  SkyTool
//
//  Created by tree on 2019/4/11.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import UIKit

class MissionBaseTask: MissionTaskType {
    var viewController: UIViewController?
    
    var type: MissionType = .none
    var name: String
    var identifier: UUID = UUID()
    
    init(_ name: String) {
        self.name = name
    }
    
    func execute() { }
}

class WebControllerTask: MissionTaskType {
    var type: MissionType
    
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
