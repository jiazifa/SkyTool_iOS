//
//  UIDevice+Ext.swift
//  SkyTool
//
//  Created by tree on 2019/4/23.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    var isNotchScreen: Bool {
        guard let window = UIApplication.shared.delegate?.window else { return false}
        if window?.safeAreaInsets.bottom ?? 0.0 > 0.0 { return true }
        return false
    }
}
