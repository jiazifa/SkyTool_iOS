//
//  UIColor+utils.swift
//  HuBeiECarSalerClient
//
//  Created by tree on 2018/12/21.
//  Copyright © 2018 tree. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    public class func randomColor() -> UIColor {
        let R = arc4random() % 256
        let B = arc4random() % 256
        let G = arc4random() % 256
        return UIColor.init(red: CGFloat(R)/255.0,
                            green: CGFloat(G)/255.0,
                            blue: CGFloat(B)/255.0,
                            alpha: 1.0)
    }
    
    public class func color(_ hex: String) -> UIColor {
        return self.color(hex, alpha: 1.0)
    }
    
    public class func color(_ hex: String, alpha: CGFloat) -> UIColor {
        var cleanString = hex.replacingOccurrences(of: "#", with: "")
        if cleanString.count == 3 {
            let startIndex = cleanString.startIndex
            
            func offsetBy(offset: Int) -> String.Index {
                return cleanString.index(startIndex, offsetBy: offset)
            }
            
            let first = String(cleanString.prefix(1))
            let second = cleanString.substring(with: Range.init(uncheckedBounds: (1, 2)))
            let third = cleanString.suffix(1)
            cleanString =  first + first + second + second + third + third
        }
        
        if cleanString.count == 6 {
            cleanString = cleanString.appending("ff")
        }
        var baseValue: UInt32 = 0
        Scanner.init(string: cleanString).scanHexInt32(&baseValue)
        let red = CGFloat(((baseValue >> 24) & 0xFF))/255.0
        let green = CGFloat(((baseValue >> 16) & 0xFF))/255.0
        let blue = CGFloat(((baseValue >> 8) & 0xFF))/255.0
        return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
