//
//  MainTabBarViewController.swift
//  GrillNowiOS
//
//  Created by tree on 2018/11/30.
//  Copyright © 2018 tree. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.tabBar.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        self.tabBar.backgroundImage = UIImage.init()
        
        self.tabBar.tintColor = UIColor.blueTheme
        self.tabBar.isTranslucent = false
        
        self.tabBar.shadowImage = UIImage.init()
        self.tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.tabBar.layer.shadowOffset = CGSize.init(width: 0, height: -2)
        self.tabBar.layer.shadowOpacity = 0.3
        
        self.setupChildViewControllers()
    }

    private func setupChildViewControllers() {
        self.addHomeViewController()
        self.addSettingsViewController()
    }
    
    private func addHomeViewController() {
        let viewController = HomeViewController()
        let navigationController = UINavigationController.init(rootViewController: viewController)
        navigationController.navigationBar.shadowImage = UIImage.init()
        let title = "首页"
        viewController.title = title
        let item = UITabBarItem.init(title: title,
                                     image: UIImage.init(named: "function"),
                                     selectedImage: UIImage.init(named: "function"))
        viewController.tabBarItem = item
        addChild(navigationController)
    }
    
    private func addSettingsViewController() {
        
        let settinsProperty = SettingsPropertyFactory(userDefaults: UserDefaults.standard)
        let factory = SettingsCellDescriptorFactory(settingsPropertyFactory: settinsProperty)
        let rootGroup = factory.rootGroup()
        let viewController = SettingsTableViewController(group: rootGroup)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.shadowImage = UIImage.init()
        let title = "设置"
        viewController.title = title
        let item = UITabBarItem.init(title: title,
                                     image: UIImage.init(named: "setting"),
                                     selectedImage: UIImage.init(named: "setting"))
        viewController.tabBarItem = item
        addChild(navigationController)
    }
}

extension UIImage {
    static func image(color: UIColor, size: CGSize = CGSize.init(width: 1.0, height: 1.0)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(.init(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
