//
//  MissionCommand.swift
//  SkyTool
//
//  Created by tree on 2019/4/14.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import UIKit

class MissionCommand: CommandType {
    var identifier: UUID
    
    var delegate: CommandDelegate?
    
    var mission: MissionTaskType
    
    var viewController: UIViewController?
    
    init(identifier: UUID = UUID(), mission: MissionTaskType) {
        self.identifier = identifier
        self.mission = mission
    }
    
    func execute() {
        switch self.mission.type {
        case .web(let url):
            guard let source = self.viewController else {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                return
            }
            let webViewController = WebViewController(url)
            source.navigationController?.pushViewController(webViewController, animated: true)
        case .rss:
            if let source = self.viewController {
                let viewController = RssListViewController()
                viewController.title = self.mission.name
                source.navigationController?.pushViewController(viewController, animated: true)
            }
        default:
            break
        }
    }
}
