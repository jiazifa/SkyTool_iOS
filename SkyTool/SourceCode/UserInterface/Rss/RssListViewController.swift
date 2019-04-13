//
//  RssListViewController.swift
//  SkyTool
//
//  Created by tree on 2019/4/13.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import UIKit

class RssListViewController: UIViewController {
    
    var controller: RssController = RssController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.background
        self.createSubViews()
        self.createConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    func createSubViews() {
        let rightItem = UIBarButtonItem.init(barButtonSystemItem: .add,
                                             target: self.controller,
                                             action: #selector(RssController.onAddClicked(_:)))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    func createConstraints() {
        
    }
}
