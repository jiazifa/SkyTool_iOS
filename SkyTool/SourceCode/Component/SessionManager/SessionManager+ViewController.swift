//
//  SessionManager+ViewController.swift
//  SkyTool
//
//  Created by tree on 2019/4/11.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import UIKit

// Toast
public extension SessionManager {
    
    func notify(message: NotifyMessage) {
        guard let rootViewController = UIApplication.shared.delegate as? AppDelegate,
            let visibilityViewController = rootViewController.rootViewController.visibilityViewController else {
            return
        }
        visibilityViewController.notify(message: message)
    }
}

