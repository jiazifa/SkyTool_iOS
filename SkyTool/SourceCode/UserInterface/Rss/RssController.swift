//
//  RssController.swift
//  SkyTool
//
//  Created by tree on 2019/4/13.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import UIKit

class RssController {
    var request = RssListRequest.init(limit: 10, pages: 0)
    
    var onReload = Delegate<Void, Void>() // need show load
    
    var rsses: [Rss] = [] {
        didSet { self.onReload.call() }
    }
    
    init() {
        self.request.fetchComplete.delegate(on: self) { (weakSelf, rsses) in
            weakSelf.rsses = rsses
        }
    }
    
    @objc(onAddClicked:)
    func onAddClicked(_ sender: UIButton) {
        
    }
    
    func load() {
        Session.shared.send(request)
    }
    
    func next() {
        self.request.backward()
        Session.shared.send(request)
    }
}
