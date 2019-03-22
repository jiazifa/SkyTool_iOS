//
//  SkyColorTest.swift
//  SkyToolTests
//
//  Created by tree on 2019/3/22.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import XCTest
@testable import SkyTool

class SkyToolColorTests: XCTestCase {
    
    var originMetaData: [String: Any]!
    
    override func setUp() {
        super.setUp()
        self.originMetaData = [
            "name": "blue"
        ]
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTransportMetaDataToData() -> Data {
        let data = try! JSONSerialization.data(withJSONObject: self.originMetaData, options: [.prettyPrinted])
        XCTAssert(data.isEmpty == false)
        return data
    }
    
    @discardableResult
    func testInitialFromLocalJsonFile() -> ColorScheme {
        
        let bundle = Bundle.init(for: SkyToolColorTests.self)
        let path = bundle.path(forResource: "blue.json", ofType: nil)
        XCTAssert(path != nil)
        let url = URL(fileURLWithPath: path!)
        let blue = try! ColorScheme.load(from: url)
        XCTAssert(blue.version == "0.1.0")
        return blue
    }
    
    func testThemeColorMap() {
        let colorScheme = self.testInitialFromLocalJsonFile()
        let first = colorScheme.schemes.first
        XCTAssert(first != nil)
    }
    
    func testInitialThemeManager() {
        let theme = self.testInitialFromLocalJsonFile()
        ThemeManager.init(themes: [theme])
        XCTAssert(ThemeManager.shared.themes.isEmpty == false)
    }
    
    func testFail() {
        
        XCTAssert(1 == 1)
        
    }
    
}
