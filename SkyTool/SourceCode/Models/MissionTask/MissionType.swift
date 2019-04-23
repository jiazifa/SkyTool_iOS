//
//  MissionType.swift
//  SkyTool
//
//  Created by tree on 2019/4/11.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import UIKit

public enum MissionType: Codable {
    case none
    case web(URL)
    case rss
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case url = "url"
    }
    
    private enum MissionStaticType: String, Codable {
        case none
        case web
        case rss
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: MissionType.CodingKeys.self)
        let type = try values.decode(MissionStaticType.self, forKey: .type)
        switch type {
        case .none:
            self = .none
        case .web:
            let url = try values.decode(URL.self, forKey: .url)
            self = .web(url)
        case .rss:
            self = .rss
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: MissionType.CodingKeys.self)
        switch self {
        case .none:
            try container.encode(MissionStaticType.none.rawValue, forKey: .type)
        case .web(let url):
            try container.encode(MissionStaticType.web.rawValue, forKey: .type)
            try container.encode(url, forKey: .url)
        case .rss:
            try container.encode(MissionStaticType.rss.rawValue, forKey: .type)
//        default:
//            fatalError()
        }
    }
    
    static var all_types: [MissionType] = [.rss]
}

extension MissionType: Equatable {
    public static func == (lhs: MissionType, rhs: MissionType) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none): return true
        case (.rss, .rss): return true
        case (.web(let lhsWeb), .web(let rhsWeb)): return lhsWeb == rhsWeb
        default: return false
        }
    }
}

extension MissionType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .rss: return "Rss 订阅"
        case .web: return "收藏网页"
        case .none: return ""
        }
    }
}

public protocol MissionTaskType: Codable {
    var identifier: UUID { get }
    
    var type: MissionType { get }
    
    var name: String { get set }
    
}

extension MissionTaskType {
    func write(to url: URL) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        try data.write(to: url)
    }
    
    static func load(from url: URL) -> MissionTaskType? {
        let data = try? Data(contentsOf: url)
        let decoder = JSONDecoder()
        return data.flatMap({
            try? decoder.decode(self, from: $0)
        })
    }
}
