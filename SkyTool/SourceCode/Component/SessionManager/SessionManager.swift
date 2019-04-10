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
    
    private(set) var accountManager: AccountManager
    
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onAccountUpdate(_:)),
                                               name: AccountManagerDidUpdateAccountsNotificationName,
                                               object: nil)
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
        let login = LoginRequest(account: account) { (account) in
            self.accountManager.addAndSelect(account)
        }
        Session.shared.send(login)
    }
    
    func delete(account: Account) {
        KeyChainManager.init(server: "\(account.userIdentifier.uuidString)").delete()
        self.accountManager.remove(account)
        self.delegate?.sessionManagerWillLogout(error: nil)
    }
}

extension SessionManager {
    @objc private func onAccountUpdate(_ notification: Notification) {
        guard let account = self.accountManager.selectedAccount else { return }
        self.delegate?.sessionManagerWillMigrateAccount(account: account)
    }
}
