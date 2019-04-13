//
//  LaunchImageViewController.swift
//  SkyTool
//
//  Created by tree on 2019/4/10.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

class LaunchImageViewController: UIViewController {
    
    lazy var nibView: LaunchScreen = {
        return LaunchScreen.loadNib()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubViews()
        self.createConstraints()
    }
    
    func setupSubViews() {
        self.view.addSubview(self.nibView)
    }
    
    func createConstraints() {
        self.nibView.autoPinEdgesToSuperviewEdges(with: .zero)
    }
    
    override var prefersStatusBarHidden: Bool { return false }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.supportedOrientations
    }
}
