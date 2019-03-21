//
//  HomeController.swift
//  SkyTool
//
//  Created by tree on 2019/3/21.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

class HomeController {
    
    let viewController: UIViewController
    
    init(sourceController: UIViewController) {
        self.viewController = sourceController
    }
    
    @objc(addButtonClicked:)
    func onAddClicked(_ sender: UIControl) {
        
    }
}
