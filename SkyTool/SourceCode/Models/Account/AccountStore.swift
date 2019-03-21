//
//  AccountStore.swift
//  SkyTool
//
//  Created by tree on 2019/3/21.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

public  final class AccountStore: NSObject {
    
    private static let directoryName = "Accounts"
    
    private let fileManager = FileManager.default
    private let directory: URL
    
    public required init(root: URL) {
        self.directory = root.appendingPathComponent(AccountStore.directoryName)
        super.init()
        fileManager.createAndProtectDirectory(at: self.directory)
    }
    
    func load() -> Set<Account> {
        return Set<Account>(loadURLs().compactMap(Account.load))
    }
    
    func load(_ uuid: UUID) -> Account? {
        return Account.load(from: url(for: uuid))
    }
    
    @discardableResult
    func add(_ account: Account) -> Bool {
        do {
            try account.write(to: url(for: account))
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    func remove(_ account: Account) -> Bool {
        do {
            guard contains(account) else { return false }
            try fileManager.removeItem(at: url(for: account))
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    static func delete(at root: URL) -> Bool {
        do {
            try FileManager.default.removeItem(at: root.appendingPathComponent(directoryName))
            return true
        } catch {
            return false
        }
    }
    
    func contains(_ account: Account) -> Bool {
        return fileManager.fileExists(atPath: url(for: account).path)
    }
    
    private func loadURLs() -> Set<URL> {
        do {
            let uuidName: (String) -> Bool = { UUID(uuidString: $0) != nil }
            let paths = try fileManager.contentsOfDirectory(atPath: directory.path)
            return Set<URL>(paths.filter(uuidName).map(directory.appendingPathComponent))
        } catch {
            return []
        }
    }
    
    private func url(for account: Account) -> URL {
        return self.url(for: account.userIdentifier)
    }
    
    private func url(for uuid: UUID) -> URL {
        return self.directory.appendingPathComponent(uuid.uuidString)
    }
}
