//
//  CacheRoute.swift
//  SkyTool
//
//  Created by tree on 2019/4/11.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation

public class CacheRoute: Codable {
    var url: URL
    
    var title: String
    
    var logoData: Data
    
}

extension CacheRoute {
    func write(to url: URL) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        try data.write(to: url, options: [.atomic])
    }
    
    static func load(from url: URL) -> CacheRoute? {
        let data = try? Data(contentsOf: url)
        let decoder = JSONDecoder()
        
        return data.flatMap { try? decoder.decode(CacheRoute.self, from: $0) }
    }
}
