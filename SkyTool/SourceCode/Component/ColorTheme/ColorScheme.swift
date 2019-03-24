//
//  ColorScheme.swift
//  GrillNowiOS
//
//  Created by tree on 2018/11/29.
//  Copyright © 2018 tree. All rights reserved.
//

import UIKit

public class ColorScheme {
    public static var shared = ColorScheme()
    
    public private(set) var colors: [String: UIColor] = [:]
    
    private init() {
        updateColors()
    }
    
    public subscript(key: String) -> UIColor {
        return ColorScheme.shared.colors[key]!
    }
    
    public static func color(for key: String) -> UIColor {
        return ColorScheme.shared.colors[key]!
    }
    
}

extension ColorScheme {
    private func updateColors() {
        self.colors["home.content.background"] = UIColor.background
    }
}
