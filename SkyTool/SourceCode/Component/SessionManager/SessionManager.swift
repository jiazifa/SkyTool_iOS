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
    
    private(set) var isTest: Bool = false
    
    private(set) var urlSession: Session
    
    private static var _shared: SessionManager?
    public static var shared: SessionManager {
        return guardSharedProperty(_shared)
    }
    
    init(appVersion: String, delegate: SessionManagerDelegate?, isTest: Bool = false) {
        self.appVersion = appVersion
        self.delegate = delegate
        guard let sharedContainerURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            preconditionFailure("Unable to get shared container URL")
        }
        print("\(sharedContainerURL)")
        self.accountManager = AccountManager(sharedDirectory: sharedContainerURL)
        self.isTest = isTest
        let configuration = URLSessionConfiguration.default
        let queue = OperationQueue.current
        self.urlSession = Session.init(configuration: configuration, queue: queue)
        super.init()
        setupNotifications()
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
        urlSession.authenticateAccount = account
        let request = UserInfoRequest(account: account)
        send(request)
        delegate?.sessionManagerWillMigrateAccount(account: account)
    }
    
    private func setupNotifications() {
        // Session With Error
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onURLSessionError(_:)),
                                               name: Session.SessionCompleteWithErrorNotification,
                                               object: nil)
        
        // Account Manager
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onAccountUpdate(_:)),
                                               name: AccountManagerDidUpdateAccountsNotificationName,
                                               object: nil)
    }
    
    @objc func onURLSessionError(_ notification: Notification) {
        guard let originalError = notification.object as? Error else { return }
        if let error = originalError as? AuthError {
            switch error {
            case .tokenExpired:
                guard let current = accountManager.selectedAccount else { return }
                delete(account: current)
            default: break
            }
        }
    }
}

// Account
extension SessionManager {
    
    func login(_ account: Account) {
        if self.isTest {
            self.accountManager.addAndSelect(account)
            return
        }
        let login = LoginRequest(account: account) { (account) in
            self.accountManager.addAndSelect(account)
        }
        urlSession.send(login)
    }
    
    func delete(account: Account) {
        urlSession.authenticateAccount = nil
        self.accountManager.remove(account)
        self.delegate?.sessionManagerWillLogout(error: nil)
    }
}

extension SessionManager {
    @objc private func onAccountUpdate(_ notification: Notification) {
        guard let account = self.accountManager.selectedAccount else { return }
        urlSession.authenticateAccount = account
        let request = UserInfoRequest(account: account)
        send(request)
        self.delegate?.sessionManagerWillMigrateAccount(account: account)
    }
    
    @discardableResult
    func send<T: Request>(_ request: T) -> SessionTask? {
        return urlSession.send(request)
    }
}
