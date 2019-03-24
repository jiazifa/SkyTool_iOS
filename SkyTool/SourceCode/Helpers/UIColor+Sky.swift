//
//  UIColor+Sky.swift
//  SkyTool
//
//  Created by tree on 2019/3/21.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit
import Foundation

@objc extension UIColor {
    
    class var blueTheme: UIColor {
        return UIColor.color("#196FD5")
    }
    
    class var stageBackground: UIColor {
        return UIColor.color("#FFF8F6")
    }
}

@objc
extension UIColor {
    static var textForeground: UIColor {
        return UIColor(red: CGFloat(51.0/255.0),
                       green: CGFloat(55.0/255.0),
                       blue: CGFloat(58.0/255.0),
                       alpha: 1)
    }
    
    static var textBackground: UIColor {
        return UIColor.white
    }
    
    static var textBlack: UIColor {
        return UIColor.color("#333333")
    }
    
    static var textDimmed: UIColor {
        return UIColor(red: CGFloat(141.0/255.0),
                       green: CGFloat(152.0/255.0),
                       blue: CGFloat(159.0/255.0),
                       alpha: 1)
    }
    
    static var textPlaceholder: UIColor {
        return UIColor(red: CGFloat(141.0/255.0),
                       green: CGFloat(152.0/255.0),
                       blue: CGFloat(159.0/255.0),
                       alpha: 0.64)
    }
    
    /// 分割线颜色
    static var separator: UIColor {
        return UIColor(red: CGFloat(141.0/255.0),
                       green: CGFloat(152.0/255.0),
                       blue: CGFloat(159.0/255.0),
                       alpha: 0.48)
    }
    
    static var barBackground: UIColor {
        return UIColor.white
    }
    
    static var background: UIColor {
        return UIColor.white
    }
    
    /// 界面view 背景颜色
    static var contentBackground: UIColor {
        return UIColor(white: 1.0, alpha: 0.97)
    }
    
}

