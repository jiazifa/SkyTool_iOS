//
//  Config.swift
//  ATDemo
//
//  Created by tree on 2019/3/6.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

class Config: NSObject {
    static var _shared: Config?
    static var shared: Config {
        return guardSharedProperty(_shared)
    }
    
    let domain: String
    
    init(_ domain: String) {
        self.domain = domain
        super.init()
        Config._shared = self
    }
    
    var host: String = "http://127.0.0.1:8091"
}
