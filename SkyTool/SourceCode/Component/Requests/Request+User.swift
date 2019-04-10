//
//  Request+User.swift
//  SkyTool
//
//  Created by tree on 2019/4/10.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation

public struct LoginRequest: Request {
    public var path: String = "/api/user/login"

    public var method: HttpMethod = .POST
    
    public var parmeter: [String : Any]
    
    public var timeout: TimeInterval = 10
    
    public var encoding: ParameterEncoding = JSONEncoding.default
    
    public var responseHandlers: [ResponseHandler] = []
    
    let loginBlock: (_ account: Account) -> ()
    
    let account: Account
    
    public func complete(_ response: TransportResponse) {
        switch response.payload {
        case .jsonDict(let x):
            guard let token = x["token"] as? String else { return }
            KeyChainManager.init(server: "\(self.account.userIdentifier.uuidString)").update(data: token)
            self.loginBlock(self.account)
        default:
            break
        }
    }
    
    init(account: Account, done: @escaping (_ account: Account) -> ()) {
        self.account = account
        if let email = account.loginCredentials?.emailAddress,
        let password = account.loginCredentials?.passwordMd5 {
            self.parmeter = ["email": email, "password": password]
        } else {
            self.parmeter = [:]
        }
        
        self.loginBlock = done
    }
}
