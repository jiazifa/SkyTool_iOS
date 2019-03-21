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
    
    fileprivate(set) var account: Account?
    
    init(account: Account?) {
        self.account = account
        super.init()
    }
    
    func startRegistration(name: String, password: String) {

    }
    
    func startChagePassword(newPsd: String) {
        
    }
    
    func startLogin(name: String, password: String) {
        let account = Account.init(name: name, userIdentifier: UUID.init())
        SessionManager.shared.login(account)
    }
}
