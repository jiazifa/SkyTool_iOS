//
//  ViewController.swift
//  SkyTool
//
//  Created by tree on 2019/3/19.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit
import PureLayout

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(viewDidClicked))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func viewDidClicked() {
        _ = Session.init()
        let r = Md5Api.init("123456")
        let task = Session.shared.send(r) { (result) in
            switch result {
            case .success(let res):
                print("\(res)")
            case .failure(let err):
                print("\(err)")
            }
        }
    }
}

struct MD5Resp: Codable {
    var target: String
    var source: String
    var type: String
}

class Md5Api: Request {
    
    typealias Response = [String: String]
    
    var method: HttpMethod = .POST
    
    var path: String = "http://127.0.0.1:8091/api/tool/encryption/md5"
    
    var parmeter: [String : Any] = [:]
    
    var timeout: TimeInterval = 30
    
    var encoding: ParameterEncoding = JSONEncoding.default
    
    init(_ source: String) {
        self.parmeter["source"] = source
    }
}
