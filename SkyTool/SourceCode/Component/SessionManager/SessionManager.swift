//
//  SessionManager.swift
//  SkyTool
//
//  Created by tree on 2019/3/21.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

public typealias LaunchOptions = [UIApplication.LaunchOptionsKey : Any]

@objc public protocol SessionManagerDelegate {
    /// 登录失败
    func sessionManagerDidFailToLogin(account: Account?, error: Error)
    /// 切换用户
    func sessionManagerWillMigrateAccount(account: Account)
    /// 用户登出(主动或被动)
    func sessionManagerWillLogout(error: Error?)
}

@objcMembers public class SessionManager: NSObject {
    public static let maxNumberAccount: Int = 1
    
    public let appVersion: String
    
    weak public var delegate: SessionManagerDelegate?
    
    private var accountManager: AccountManager
    
    private static var _shared: SessionManager?
    public static var shared: SessionManager {
        return guardSharedProperty(_shared)
    }
    
    init(appVersion: String, delegate: SessionManagerDelegate?) {
        self.appVersion = appVersion
        self.delegate = delegate
        guard let sharedContainerURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            preconditionFailure("Unable to get shared container URL")
        }
        print("\(sharedContainerURL)")
        self.accountManager = AccountManager(sharedDirectory: sharedContainerURL)
        super.init()
        SessionManager._shared = self
    }
    
    public override init() {
        fatalError("init() not implemented")
    }
    
    public func start(launchOptions: LaunchOptions) {
        if let account = accountManager.selectedAccount {
            self.selectInitialAccount(account, launchOptions: launchOptions)
        }
    }
    
    private func selectInitialAccount(_ account: Account, launchOptions: LaunchOptions) {
        delegate?.sessionManagerWillMigrateAccount(account: account)
    }
}

// Account
extension SessionManager {
    
    func login(_ account: Account) {
        self.accountManager.addAndSelect(account)
        self.delegate?.sessionManagerWillMigrateAccount(account: account)
    }
}

extension SessionManager {
    @objc private func onAccountUpdate(_ notification: Notification) {
        
    }
}
