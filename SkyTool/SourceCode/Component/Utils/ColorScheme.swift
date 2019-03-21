//
//  ColorScheme.swift
//  GrillNowiOS
//
//  Created by tree on 2018/11/29.
//  Copyright © 2018 tree. All rights reserved.
//

import UIKit

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
