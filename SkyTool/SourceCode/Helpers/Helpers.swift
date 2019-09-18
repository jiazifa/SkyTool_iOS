//
//  Helpers.swift
//  ATDemo
//
//  Created by tree on 2019/3/6.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit
import Foundation

@objc
public extension UITableView {
    
    class func tableView() -> UITableView {
        let tableView: UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.setInitProperty()
        return tableView
    }
    
    class func groupTableView() -> UITableView {
        let tableView: UITableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.setInitProperty()
        return tableView
    }
    
    private func setInitProperty() {
        self.indicatorStyle = .white
        self.isScrollEnabled = true
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.clear
        self.backgroundView = nil
        self.tableFooterView = UIView.init()
        
        self.sectionHeaderHeight = 0.0
        self.sectionFooterHeight = 0.0
        
        self.separatorStyle = .singleLine
        
        if #available(iOS 11.0, *) {
            self.insetsContentViewsToSafeArea = true
        }
    }
}


func guardSharedProperty<T>(_ input: T?) -> T {
    guard let shared = input else {
        Log.fatalError("Use \(T.self) before setup. " +
            "Please call `LoginManager.setup` before you do any other things in LineSDK.")
    }
    return shared
}

public let decoder = JSONDecoder()
public let encoder = JSONEncoder()

/// decode An object to Codable
///
/// - Parameter json: json object
/// - Returns: value after decode
/// - Throws: when JSONSerialization to data or decode may throw an error
public func decode<T: Codable>(json: Any) throws -> T {
    let data = try JSONSerialization.data(withJSONObject: json, options: [])
    return try decoder.decode(T.self, from: data)
}

/// encode Codable to Data
///
/// - Parameter source: Codable object
/// - Returns: Data
/// - Throws: when encode crashed
public func encode<T: Codable>(source: T) throws -> Data {
    return try encoder.encode(source)
}
