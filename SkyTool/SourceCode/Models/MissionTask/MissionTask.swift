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
    var identifier: UUID
    
    var type: MissionType
    
    var name: String
    
    init(identifier: UUID = UUID(), name: String, type: MissionType) {
        self.identifier = identifier
        self.name = name
        self.type = type
    }
}


/// 打开网页的命令
class WebControllerTask: MissionBaseTask {
    var viewController: UIViewController?
    
    init(_ name: String, url: URL) {
        super.init(name: name, type: .none)
        self.type = .web(url)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    func execute() {
        switch self.type {
        case .web(let url):
            guard let topViewController = self.viewController,
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
