//
//  UIColor+Sky.swift
//  SkyTool
//
//  Created by tree on 2019/3/21.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

@objc extension UIColor {
    
    class var blueTheme: UIColor {
        return UIColor.color("#196FD5")
    }
    
    class var stageBackground: UIColor {
        return UIColor.color("#FFF8F6")
    }
}

protocol ThemeProtocol {
    
}

class SkyTheme: ThemeProtocol {
    
    private static var _shared: SkyTheme?
    static var shared: SkyTheme {
        return guardSharedProperty(_shared)
    }
}

public class ThemeManager {
    static var shared: ThemeManager = ThemeManager()
    
    var themes = [ThemeProtocol]()
}
