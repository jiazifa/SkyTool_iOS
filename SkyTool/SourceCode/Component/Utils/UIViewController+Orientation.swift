//
//  UIViewController+Orientation.swift
//  GrillNowiOS
//
//  Created by tree on 2018/11/23.
//  Copyright © 2018 tree. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    @objc var supportedOrientations: UIInterfaceOrientationMask {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            switch self.traitCollection.horizontalSizeClass {
            case .compact:
                return .portrait
            case .regular:
                return .all
            default:
                return .all
            }
        case .phone:
            return .portrait
        default:
            return .portrait
        }
    }
}

/// topViewController
public extension UIApplication {
    class func topViewController(from base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController)
        -> UIViewController? {
            
            if let nav = base as? UINavigationController {
                return topViewController(from: nav.visibleViewController)
            }else if let tab = base as? UITabBarController, let selected = tab.selectedViewController{
                    return topViewController(from: selected)
            }else if let presented = base?.presentedViewController {
                return topViewController(from: presented)
            }
            return base
            
    }
}
