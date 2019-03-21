//
//  AuthenNavigationViewController.swift
//  SkyTool
//
//  Created by tree on 2019/3/21.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit
import PushKit

class AuthenNavigationViewController: UINavigationController {
    
    fileprivate(set) var backButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarHidden(true, animated: false)
        self.setupBackButton()
        self.createConstraints()
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.topViewController?.prefersStatusBarHidden ?? false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController?.preferredStatusBarStyle ?? .lightContent
    }
    
    func setupBackButton() {
        
    }
    
    func createConstraints() {
        
    }
}
