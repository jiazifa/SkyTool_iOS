//
//  Request_Rss.swift
//  SkyTool
//
//  Created by tree on 2019/4/13.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation

public class RssListRequest: TransportRequest {
    
    public let fetchComplete = Delegate<[Rss], Void>()
    
    public var rsses: [Rss] = []
    
    private(set) var limit: Int
    
    private(set) var pages: Int
    
    private(set) var canBackward: Bool = true
    
    init(limit: Int, pages: Int) {
        self.limit = limit
        self.pages = pages
        super.init(path: "/api/rss/content/list", params: [:])
        self.generatParams()
    }
    
    private func generatParams() {
        self.parmeter = [
            "pages": max(self.pages, 0),
            "limit": self.limit
        ]
    }
    
    public func reload() {
        self.pages = 0
        self.rsses.removeAll()
        self.generatParams()
    }
    
    public func backward() {
        self.pages += 1
        self.generatParams()
    }
    
    public override func onComplete(_ response: TransportResponse) {
        if response.sessionError != nil {
            self.fetchComplete.call(self.rsses)
            return
        }
        switch response.payload {
        case .jsonDict(let dict):
            if let pageInfo: PageWrapper<Rss> = try? decode(json: dict) {
                let rssList = pageInfo.list
                let total = pageInfo.total
                if total == self.limit {
                    self.canBackward = true
                } else {
                    self.canBackward = false
                }
                self.rsses.append(contentsOf: rssList)
                self.fetchComplete.call(self.rsses)
            }
            
        case .none:
            break
        default:
            Log.fatalError("error handler")
        }
    }
}

public class RssReadedRequest: TransportRequest {
    
    init(rss: Rss) {
        let params = [ "url": rss.link.absoluteString ]
        super.init(path: "/api/rss/record", params: params)
    }
    
}
