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
    var coverImgUrl: URL?
    var publishedDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case link = "link"
        case id = "id"
        case base = "base"
        case coverImgUrl = "cover_img"
        case publishedDate = "published_time"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Rss.CodingKeys.self)
        self.title = try values.decode(String.self, forKey: .title)
        self.link = try values.decode(URL.self, forKey: .link)
        self.id = try values.decode(Int.self, forKey: .id)
        self.base = try values.decode(URL.self, forKey: .base)
        if let cover_imgString = try values.decode(String?.self, forKey: .coverImgUrl) {
            self.coverImgUrl = URL(string: cover_imgString)
        }
        if let publish = try values.decode(Float?.self, forKey: .publishedDate) {
            self.publishedDate = Date.init(timeIntervalSince1970: TimeInterval(publish))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Rss.CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(link, forKey: .link)
        try container.encode(id, forKey: .id)
        try container.encode(base, forKey: .base)
        try container.encode(coverImgUrl, forKey: .coverImgUrl)
        try container.encode(publishedDate, forKey: .publishedDate)
    }
    
}
