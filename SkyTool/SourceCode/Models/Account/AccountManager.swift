//
//  AccountManager.swift
//  SkyTool
//
//  Created by tree on 2019/3/21.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

public let AccountManagerDidUpdateAccountsNotificationName = Notification.Name("AccountManagerDidUpdateAccountsNotification")

fileprivate extension UserDefaults {
    static let selectedAccountKey = "AccountManagerSelectedAccountKey"
    
    var selectedAccountIdentifier: UUID? {
        get { return string(forKey: UserDefaults.selectedAccountKey).flatMap(UUID.init) }
        set { set(newValue?.uuidString, forKey: UserDefaults.selectedAccountKey) }
    }
}

@objcMembers public final class AccountManager: NSObject {
    
    private let defaults = UserDefaults.standard
    
    private let store: AccountStore
    
    public private(set) var accounts: [Account] = []
    
    public private(set) var selectedAccount: Account?
    
    @objc(initWithSharedDirectory:)
    public init(sharedDirectory: URL) {
        store = AccountStore.init(root: sharedDirectory)
        super.init()
        updateAccounts()
    }
    
    public static func delete(at root: URL) {
        AccountStore.delete(at: root)
        UserDefaults.standard.selectedAccountIdentifier = nil
    }
    
    @objc(addOrUpdateAccount:)
    public func addOrUpdate(_ account: Account) {
        store.add(account)
        updateAccounts()
    }
    
    @objc(addAndSelectAccount:)
    public func addAndSelect(_ account: Account) {
        addOrUpdate(account)
        self.select(account)
    }
    
    @objc(removeAccount:)
    public func remove(_ account: Account) {
        store.remove(account)
        if selectedAccount == account {
            defaults.selectedAccountIdentifier = nil
        }
        updateAccounts()
    }
    
    @objc(selectAccount:)
    public func select(_ account: Account) {
        guard accounts.contains(account) == true else {
            fatalError()
        }
        guard account != selectedAccount else { return }
        defaults.selectedAccountIdentifier = account.userIdentifier
        updateAccounts()
    }
    
    public func acount(with id: UUID) -> Account? {
        return accounts.first(where: { $0.userIdentifier == id })
    }
}

extension AccountManager {
    private func updateAccounts() {
        var updatedAccounts = [Account]()
        
        for account in computeSortedAccounts() {
            if let existingAccount = self.account(with: account.userIdentifier) {
                existingAccount.updateWith(account)
                updatedAccounts.append(existingAccount)
            } else {
                updatedAccounts.append(account)
            }
        }
        
        accounts = updatedAccounts
        
        let cumputedAccount = computeSelectedAccount()
        if let account = cumputedAccount,
            let exisitingAccount = self.account(with: account.userIdentifier) {
            exisitingAccount.updateWith(account)
            self.selectedAccount = exisitingAccount
        } else {
            self.selectedAccount = cumputedAccount
        }
        NotificationCenter.default.post(name: AccountManagerDidUpdateAccountsNotificationName, object: self)
    }
    
    public func account(with id: UUID) -> Account? {
        return accounts.first(where: { return $0.userIdentifier == id })
    }
    
    private func computeSelectedAccount() -> Account? {
        return defaults.selectedAccountIdentifier.flatMap(store.load)
    }
    
    private func computeSortedAccounts() -> [Account] {
        return store.load().sorted(by: { (lhs, rhs) -> Bool in
            return lhs.userIdentifier.uuidString > rhs.userIdentifier.uuidString
        })
    }
}
