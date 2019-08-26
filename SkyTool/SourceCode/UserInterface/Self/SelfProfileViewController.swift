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
    
    private var imageController: PickerImageController {
        return PickerImageController.init(hostViewController: self)
    }
    
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
        self.scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.updateUserInfo()
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
        self.updateUserInfo()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(modifyIcon(_:)))
        self.headView.imageView.isUserInteractionEnabled = true
        self.headView.imageView.addGestureRecognizer(tap)
    }
    
    @objc func modifyIcon(_ tap: UITapGestureRecognizer) {
        self.imageController.beginPick { (images) in
            guard let images = images else { return }
            Log.print("\(images.count)")
        }
    }
    
    func updateUserInfo() {
        self.headView.titleLabel.text = self.controller.account.name
        self.headView.imageView.setImageWith(self.controller.account.imageURL, options: [])
    }
    
    func createConstraints() {
        self.settingsViewController.view.setContentHuggingPriority(.required, for: .vertical)
        self.settingsViewController.view.setContentCompressionResistancePriority(.required, for: .vertical)
        self.settingsViewController.tableView.setContentCompressionResistancePriority(.required, for: .vertical)
        self.settingsViewController.tableView.setContentHuggingPriority(.required, for: .vertical)
        
        self.scrollView.autoPinEdgesToSuperviewEdges()
        
        self.container.autoMatch(.width, to: .width, of: self.scrollView)
        self.container.autoMatch(.height, to: .height, of: self.scrollView, withOffset: 10)
        
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
