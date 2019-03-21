//
//  KeyChainManager.swift
//  SkyTool
//
//  Created by tree on 2019/3/21.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

public class KeyChainManager: NSObject {
    
    let server: String
    
    init(server: String) {
        self.server = server
    }

    private func queryDictionary() -> [String: Any] {
        var queryDict = [String:Any]()
        // 设置条件存储的类型
        queryDict[kSecClass as String] = kSecClassGenericPassword
        // 设置存储数据的标记
        queryDict[kSecAttrService as String] = self.server
        queryDict[kSecAttrAccount as String] = self.server
        // 设置数据访问属性
        queryDict[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
        return queryDict
    }
    
    func save(data: Any) -> Bool {
        var params = self.queryDictionary()
        SecItemDelete(params as CFDictionary)
        // 设置数据
        params[kSecValueData as String] = NSKeyedArchiver.archivedData(withRootObject: data)
        // 进行存储数据
        let saveState = SecItemAdd(params as CFDictionary, nil)
        if saveState == noErr  {
            return true
        }
        return false
    }
    
    func update(data: Any) -> Bool {
        // 获取更新的条件
        let params = self.queryDictionary()
        // 创建数据存储字典
        var updata = [String: Any]()
        // 设置数据
        updata[kSecValueData as String] = NSKeyedArchiver.archivedData(withRootObject: data)
        // 更新数据
        let updataStatus = SecItemUpdate(params as CFDictionary, update as! CFDictionary)
        if updataStatus == noErr {
            return true
        }
        return false
    }
    
    func delete() {
        // 获取删除的条件
        let params = self.queryDictionary()
        // 删除数据
        SecItemDelete(params as CFDictionary)
    }
    
    func query() -> Any? {
        var idObject:Any?
        // 获取查询条件
        var params = self.queryDictionary()
        // 提供查询数据的两个必要参数
        params[kSecReturnData as String] = kCFBooleanTrue
        params[kSecMatchLimit as String] = kSecMatchLimitOne
        // 创建获取数据的引用
        var queryResult: AnyObject?
        // 通过查询是否存储在数据
        let readStatus = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(params as CFDictionary, UnsafeMutablePointer($0))
        }
        if readStatus == errSecSuccess {
            if let data = queryResult as! NSData? {
                idObject = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as Any
            }
        }
        return idObject as Any
    }
}
