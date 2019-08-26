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
    
    let session: Session = Session.init(configuration: .default, queue: nil)

    override func setUp() {
        _ = Config.init("")
    }

    override func tearDown() {
        
    }
    
    func testRequest() {
        let promise = expectation(description: "Simple Request")
        let transportRequest = TransportRequest.init(path: "/api/test", params: ["key1": "value1"])
        let resp: ResponseHandler = { resp in
            switch resp.payload {
            case .jsonDict(let dic):
                XCTAssertNotNil(dic["params"])
                promise.fulfill()
            default: break
            }
        }
        
        transportRequest.responseHandlers.append(resp)
        session.send(transportRequest)
        waitForExpectations(timeout: 20, handler: nil)
    }

}
