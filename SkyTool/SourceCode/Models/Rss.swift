//
//  Rss.swift
//  SkyTool
//
//  Created by tree on 2019/4/13.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation

public struct Rss: Codable {
    var title: String
    var link: URL
    var id: Int
    var base: URL
}
