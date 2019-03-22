//
//  Account.swift
//  SkyTool
//
//  Created by tree on 2019/3/21.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

public final class Account: NSObject, Codable {
    
    public var name: String
    
    public var imageData: Data?
    
    public var loginCredentials: LoginCredentials?
    
    public private(set) var user_id: Int?
    
    public let userIdentifier: UUID
    
    init(name: String,
         userIdentifier: UUID,
         loginCredentials: LoginCredentials?=nil) {
        self.name = name
        self.userIdentifier = userIdentifier
        self.loginCredentials = loginCredentials
        super.init()
    }
    
    public func updateWith(_ account: Account) {
        guard self.userIdentifier == account.userIdentifier else { return }
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Account else { return false }
        return userIdentifier == other.userIdentifier
    }
    
    public override var hash: Int {
        return userIdentifier.hashValue
    }
}

extension Account {
    func write(to url: URL) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        try data.write(to: url, options: [.atomic])
    }
    
    static func load(from url: URL) -> Account? {
        let data = try? Data(contentsOf: url)
        let decoder = JSONDecoder()
        
        return data.flatMap { try? decoder.decode(Account.self, from: $0) }
    }
}
