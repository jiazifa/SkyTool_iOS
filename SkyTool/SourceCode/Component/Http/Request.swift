//
//  Request.swift
//  SkyTool
//
//  Created by tree on 2019/3/19.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

enum HttpMethod: String {
    case GET
    case POST
}

protocol HttpDecodable {
    static func parse(data: Data) -> Self?
}

extension String: HttpDecodable {
    static func parse(data: Data) -> String? {
        return String.init(data: data, encoding: .utf8)
    }
}

extension Dictionary: HttpDecodable {
    static func parse(data: Data) -> Dictionary<Key, Value>? {
        return try! JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? Dictionary<Key, Value> ?? nil
    }
}

protocol Request {
    associatedtype Response: HttpDecodable
    
    var path: String { get }
    var method: HttpMethod { get }
    var parmeter: [String: Any] { get }
    var timeout: TimeInterval { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var encoding: ParameterEncoding { get }
}

extension Request {
    var cachePolicy: URLRequest.CachePolicy {
        return URLRequest.CachePolicy.reloadIgnoringLocalCacheData
    }
}
