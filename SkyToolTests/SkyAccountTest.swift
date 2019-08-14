//
//  SkyAccountTest.swift
//  SkyToolTests
//
//  Created by tree on 2019/8/14.
//  Copyright © 2019 treee. All rights reserved.
//

import XCTest
import Foundation
import YYKit.NSString_YYAdd
@testable import SkyTool

class SkyAccountTest: XCTestCase {
    
    var manager: AccountManager!
    
    let testEmail: String = "testaccount@test.com"
    let testPhone: String = "100000000092"
    let testPwdMd5: String = "e10adc3949ba59abbe56e057f20f883e"
    
    lazy var testAccountCredentials: LoginCredentials = {
        LoginCredentials.init(email: testEmail, phone: testPhone, passwordMd5: testPwdMd5)
    }()
    
    var sharedContainerURL: URL = {
        guard var sharedContainerURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            preconditionFailure("Unable to get shared container URL")
        }
        return sharedContainerURL
    }()
    override func setUp() {
        sharedContainerURL.appendPathComponent("testDir")
        self.manager = AccountManager.init(sharedDirectory: sharedContainerURL)
    }
    
    override func tearDown() {
        AccountManager.delete(at: sharedContainerURL)
    }
    
    /// 测试是否能正常添加账户
    func testAddAccount() {
        let login = testAccountCredentials
        let identifier = UUID()
        let account = Account.init(userIdentifier: identifier, loginCredentials: login)
        manager.addOrUpdate(account)
        XCTAssertNotNil(manager.account(with: identifier))
    }
    /// 测试是否会重复添加用户
    func testAddDuplicateAccount() {
        let login = testAccountCredentials
        let identifier = UUID()
        let account = Account.init(userIdentifier: identifier, loginCredentials: login)
        manager.addOrUpdate(account)
        manager.addAndSelect(account)
        XCTAssertEqual(1, manager.accounts.count)
        XCTAssertNotNil(manager.selectedAccount)
    }
    
    func testStoreAccount() {
        let login = testAccountCredentials
        let identifier = UUID()
        let account = Account.init(userIdentifier: identifier, loginCredentials: login)
        manager.addOrUpdate(account)
        manager.remove(account)
        XCTAssertNil(manager.selectedAccount)
    }
}
