//
//  Request_Rss.swift
//  SkyTool
//
//  Created by tree on 2019/4/13.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation

public class RssListRequest: Request {
    public var path: String = "/api/rss/content/list"
    
    public var method: HttpMethod = .POST
    
    public var parmeter: [String : Any] = [:]
    
    public var timeout: TimeInterval = 20
    
    public var encoding: ParameterEncoding = JSONEncoding.default
    
    public var responseHandlers: [ResponseHandler] = []
    
    public let fetchComplete = Delegate<[Rss], Void>()
    
    public var rsses: [Rss] = []
    
    private(set) var limit: Int
    
    private(set) var pages: Int
    
    private(set) var canBackward: Bool = true
    
    init(limit: Int, pages: Int) {
        self.limit = limit
        self.pages = pages
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
    
    public func complete(_ response: TransportResponse) {
        switch response.payload {
        case .jsonDict(let x):
            guard let list = x["list"] as? [Any] else { return }
            guard let data = try? JSONSerialization.data(withJSONObject: list, options: []),
                let rssList = try? decoder.decode([Rss].self, from: data) else {
                    return
            }
            if let total = x["total"] as? Int,
                total == self.limit {
                self.canBackward = true
            } else {
                self.canBackward = false
            }
            self.rsses.append(contentsOf: rssList)
            self.fetchComplete.call(self.rsses)
        case .none:
            break
        default:
            Log.fatalError("error handler")
        }
    }
}
