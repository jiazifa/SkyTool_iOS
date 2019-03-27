//
//  SkyRequestTests.swift
//  SkyToolTests
//
//  Created by tree on 2019/3/24.
//  Copyright © 2019 treee. All rights reserved.
//

import XCTest
import Foundation
@testable import SkyTool

class SkyRequestTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
        
    }
    
    func testRequest() {
        let transportRequest = TransportRequest.init(path: "/api/test", params: ["key1": "value1"])
        let resp: ResponseHandler = { resp in
            switch resp.payload {
            case .jsonDict(_):
                XCTAssert(1 == 1)
                break
            case .none:
                XCTAssert(1 == 2)
                break
            }
        }
        
        transportRequest.responseHandlers.append(resp)
        Session.init().send(transportRequest)
    }

}
