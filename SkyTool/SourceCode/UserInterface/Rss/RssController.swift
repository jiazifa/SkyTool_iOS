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
    
    func addRssLink(_ link: String?) {
        guard let link = link else { return }
        let request = TransportRequest(path: "/api/rss/add",
                                       params: ["source": link])
        let handler: ResponseHandler = { response in
            Log.print("\(response.payload)")
            if response.httpStatusCode == 200 {
                Log.print("已添加")
            }
        }
        request.responseHandlers.append(handler)
        Session.shared.send(request)
    }
    
    func load() {
        Session.shared.send(request)
    }
    
    func next() {
        guard self.request.canBackward else { return }
        self.request.backward()
        Session.shared.send(request)
    }
}
