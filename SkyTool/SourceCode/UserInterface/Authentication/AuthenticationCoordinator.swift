//
//  AuthenticationCoordinator.swift
//  AFanTiCheMerchantClient
//
//  Created by tree on 2019/3/20.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

class AuthenticationCoordinator: NSObject {
    
    var currentViewController: UIViewController?
    
    fileprivate(set) var account: Account
    
    init(account: Account?) {
        self.account = account ?? Account.init(name: "", userIdentifier: UUID.init())
        super.init()
    }
    
    func startRegistration(name: String, password: String) {

    }
    
    func startChagePassword(newPsd: String) {
        
    }
    
    func startLogin(name: String, password: String) {
        
        let credentials = LoginCredentials(email: name, phone: nil, hasPassword: true)
        account.loginCredentials = credentials
        SessionManager.shared.login(account)
    }
}
