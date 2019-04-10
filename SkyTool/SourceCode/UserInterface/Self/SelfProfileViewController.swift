//
//  SelfProfileViewController.swift
//  SkyTool
//
//  Created by tree on 2019/4/9.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

class SelfProfileViewController: UIViewController {
    lazy var headView: SelfProfileHeaderView = {
        return SelfProfileHeaderView.loadNib()
    }()
    
    let settingsViewController: SettingsTableViewController
    
    let scrollView = UIScrollView()
    
    let container = UIView()
    
    let controller: SelfProfileController
    
    init(controller: SelfProfileController, group: SettingsInternalGroupCellDescriptorType) {
        self.controller = controller
        self.settingsViewController = SettingsTableViewController(group: group)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubViews()
        self.createConstraints()
    }
    
    func createSubViews() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.container)
        self.scrollView.showsVerticalScrollIndicator  = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.container.addSubview(self.headView)
        self.add(self.settingsViewController, to: self.container)
        self.settingsViewController.tableView.showsVerticalScrollIndicator = false
        self.settingsViewController.tableView.isScrollEnabled = false
        if let data = self.controller.account.imageData {
            self.headView.imageView.image = UIImage.init(data: data)
        }
        if self.controller.account.name.isEmpty,
            let name = self.controller.account.loginCredentials?.emailAddress {
            self.headView.titleLabel.text = name
        }
    }
    
    func createConstraints() {
        self.settingsViewController.view.setContentHuggingPriority(.required, for: .vertical)
        self.settingsViewController.view.setContentCompressionResistancePriority(.required, for: .vertical)
        self.settingsViewController.tableView.setContentCompressionResistancePriority(.required, for: .vertical)
        self.settingsViewController.tableView.setContentHuggingPriority(.required, for: .vertical)
        
        self.scrollView.autoPinEdgesToSuperviewEdges()
        
        self.container.autoMatch(.width, to: .width, of: self.scrollView)
        self.container.autoMatch(.height, to: .height, of: self.scrollView)
        
        self.headView.autoPinEdge(toSuperviewEdge: .top)
        self.headView.autoPinEdge(toSuperviewEdge: .left)
        self.headView.autoPinEdge(toSuperviewEdge: .right)
        self.headView.autoSetDimension(.height, toSize: 200)

        self.settingsViewController.view.autoPinEdge(.top, to: .bottom, of: self.headView)
        self.settingsViewController.view.autoPinEdge(toSuperviewEdge: .left)
        self.settingsViewController.view.autoPinEdge(toSuperviewEdge: .right)
        self.settingsViewController.view.autoPinEdge(toSuperviewEdge: .bottom)
        
    }
}
