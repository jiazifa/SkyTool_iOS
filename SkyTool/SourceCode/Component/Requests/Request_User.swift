//
//  Request+User.swift
//  SkyTool
//
//  Created by tree on 2019/4/10.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation

final public class LoginRequest: TransportRequest {
    let loginBlock: (_ account: Account) -> ()
    
    let account: Account
    
    public override func complete(_ response: TransportResponse) {
        switch response.payload {
        case .jsonDict(let x):
            guard let token = x["token"] as? String,
                let tokenData = token.data(using: .utf8) else { return }
            self.account.tokenData = tokenData
            self.loginBlock(self.account)
        default:
            break
        }
    }
    
    init(account: Account, done: @escaping (_ account: Account) -> ()) {
        self.account = account
        var p: [String: String] = [:]
        if let email = account.loginCredentials?.emailAddress,
        let password = account.loginCredentials?.passwordMd5 {
            p = ["email": email, "password": password]
        }
        self.loginBlock = done
        super.init(path: "/api/user/login", params: p)
    }
}

final public class UserInfoRequest: TransportRequest {
    public var account: Account
    
    init(account: Account) {
        self.account = account
        super.init(path: "/api/user/info", params: [:])
    }
    
    public override func complete(_ response: TransportResponse) {
        switch response.payload {
        case .jsonDict(let x):
            guard let data = try? JSONSerialization.data(withJSONObject: x, options: []),
                let info = try? JSONDecoder().decode(UserInfo.self, from: data) else {
                return
            }
            self.account.userInfo = info
        default:
            break
        }
    }
}
