//
//  LoginCredentials.swift
//  SkyTool
//
//  Created by tree on 2019/3/21.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

public final class LoginCredentials: NSObject, Codable {
    public let emailAddress: String?
    public let phoneNumber: String?
    
    public let passwordMd5: String?
    
    public init(email: String?, phone: String?, passwordMd5: String?) {
        self.emailAddress = email
        self.phoneNumber = phone
        self.passwordMd5 = passwordMd5
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        guard let otherCredentials = object as? LoginCredentials else { return false }
        let email = self.emailAddress == otherCredentials.emailAddress
        let phone = self.phoneNumber == otherCredentials.phoneNumber
        let has = self.passwordMd5 == otherCredentials.passwordMd5
        return email && phone && has
    }
    
    override public var hash: Int {
        var hasher = Hasher()
        hasher.combine(self.emailAddress)
        hasher.combine(self.phoneNumber)
        hasher.combine(self.passwordMd5)
        return hasher.finalize()
    }
}
