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
