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
    
    var name: String
    
    var identifier: UUID = UUID()
    
    init(_ name: String, url: URL) {
        self.name = name
        self.type = .web(url)
    }
    
    func execute() {
        switch self.type {
        case .web(let url):
            guard let topViewController = UIApplication.shared.topmostController(),
                let navigation = topViewController.navigationController else {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                return
            }
            let webViewController = WebViewController(url)
            navigation.pushViewController(webViewController, animated: true)
        default:
            fatalError()
        }
    }
}

struct MissionBaseTask: MissionTaskType {
    var identifier: UUID
    
    var type: MissionType
    
    var name: String
    
    init(identifier: UUID = UUID(), name: String, type: MissionType) {
        self.identifier = identifier
        self.name = name
        self.type = type
    }
}
