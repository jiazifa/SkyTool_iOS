
//
//  PhotoPickerOptions.swift
//  SkyTool
//
//  Created by tree on 2019/4/16.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import UIKit

class PhotoPickerOptions {
    // 选中的颜色
    var selectedBorderColor: UIColor = UIColor.blue
    var selectedBorderWidth: CGFloat = 5
    
    // 最多数量
    var maxiumSelecteCount: Int = 1
    
    static var `default` = PhotoPickerOptions.defaultOption()
    
    private static func defaultOption() -> PhotoPickerOptions {
        return PhotoPickerOptions.init()
    }
    
    init() {}
}
