//
//  DebugOption.swift
//  HuBeiECarSalerClient
//
//  Created by tree on 2018/12/23.
//  Copyright © 2018 tree. All rights reserved.
//

import Foundation

public func DLog<T>(_ message: T,
                    file: String = #file,
                    method: String = #function,
                    line: Int = #line) {
    #if DEBUG
    print("\((file as NSString).lastPathComponent), \(method)[\(line)]: \(message)")
    #endif
}

public struct Log {
    static func assertionFailure(_ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) {
        Swift.assertionFailure("[FAILURE] \(message())", file: file, line: line)
    }
    
    static func fatalError(_ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) -> Never {
        Swift.fatalError("[ERROR] \(message())", file: file, line: line)
    }
    
    static func print(_ items: Any..., file: StaticString = #file, line: UInt = #line) {
        let s = items.reduce("") { result, next in
            return result + String(describing: next)
        }
        var fileName: String = ""
        if let f = file.description.split(separator: "/").last {
            fileName = f.description
        }
        Swift.print("[LOG] \(fileName)|\(line) \(s)")
    }
}
