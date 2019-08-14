//
//  AuthenticationCoordinator.swift
//  AFanTiCheMerchantClient
//
//  Created by tree on 2019/3/20.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit
import YYKit

class AuthenticationCoordinator: NSObject {
    
    var currentViewController: UIViewController?
    
    fileprivate(set) var account: Account
    
    init(account: Account?) {
        self.account = account ?? Account.init(userIdentifier: UUID.init())
        super.init()
    }
    
    func startRegistration(name: String, password: String) {
    }
    
    func startChagePassword(newPsd: String) {
        
    }
    
    func startLogin(name: String, password: String) {
        let newPassword = password.md5()
        let credentials = LoginCredentials(email: name, phone: nil, passwordMd5: newPassword!)
        account.loginCredentials = credentials
        SessionManager.shared.login(account)
    }
}
