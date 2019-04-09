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
        return SelfProfileHeaderView.loadFromNib()
    }()
    
    let scrollView = UIScrollView()
    
    let container = UIView()
    
    let controller: SelfProfileController
    
    init(controller: SelfProfileController) {
        self.controller = controller
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
    
    func createConstraints() {
        self.headView.autoPinEdge(toSuperviewEdge: .top)
        self.headView.autoPinEdge(toSuperviewEdge: .left)
        self.headView.autoPinEdge(toSuperviewEdge: .right)
        self.headView.autoSetDimension(.height, toSize: 200)
        
        self.container.autoPinEdgesToSuperviewEdges()
        self.container.autoMatch(.width, to: .width, of: self.scrollView)
        
        self.scrollView.autoPinEdgesToSuperviewEdges()
    }
    
    func createSubViews() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.container)
        self.container.addSubview(self.headView)
        self.headView.backgroundColor = UIColor.green
    }
}
