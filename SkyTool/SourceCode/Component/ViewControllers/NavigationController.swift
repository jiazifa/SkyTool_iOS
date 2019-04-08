//
//  NavigationController.swift
//  SkyTool
//
//  Created by tree on 2019/4/8.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {
    // MARK: property
    
    // MARK: systemCycle
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        let color = UIColor.black
        let tinyColor = UIColor.white
        self.navigationBar.barTintColor = color
        self.navigationBar.tintColor = tinyColor
        self.navigationBar.isTranslucent = false
        self.navigationBar.titleTextAttributes = [.foregroundColor: tinyColor,
                                                  .font: UIFont.normalSemiboldFont]
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: delegate&dataSource
    
    // MARK: -
    // MARK: public
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        let backitem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = backitem
        super.pushViewController(viewController, animated: animated)
    }
    
    @discardableResult
    override func popViewController(animated: Bool) -> UIViewController? {
        return super.popViewController(animated: animated)
    }
    
    @objc func backForward() {
        popViewController(animated: true)
    }
    
    // MARK: -
    // MARK: 转屏设置
    override var shouldAutorotate: Bool {
        guard self.topViewController != nil else {
            return false
        }
        return (self.topViewController?.shouldAutorotate)!
    }
    //支持的转屏方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        guard self.topViewController != nil else {
            return .portrait
        }
        return (self.topViewController?.supportedInterfaceOrientations)!
    }
    
}
