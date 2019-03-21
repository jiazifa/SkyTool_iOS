//
//  Reusable.swift
//  GrillNowiOS
//
//  Created by tree on 2018/11/29.
//  Copyright © 2018 tree. All rights reserved.
//

import Foundation
import UIKit

public protocol Reusable {
    static var reuseIdentifier: String { get }

    var reuseIdentifier: String? { get }
}

public extension Reusable {
    static var reuseIdentifier: String {
        // 如果想使用保留字，需要使用反引号
        guard let `class` = self as? AnyClass else {return "\(self)" }
        return NSStringFromClass(`class`)
    }

    var reuseIdentifier: String? {
        return type(of: self).reuseIdentifier
    }
}

extension UITableViewCell: Reusable {}
extension UICollectionReusableView: Reusable {}
