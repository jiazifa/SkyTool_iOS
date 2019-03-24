//
//  Request.swift
//  SkyTool
//
//  Created by tree on 2019/3/19.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

public enum HttpMethod: String {
    case GET
    case POST
}

public typealias ResponseHandler = (TransportResponse) -> ()
public protocol Request {
    var path: String { get }
    var method: HttpMethod { get }
    var parmeter: [String: Any] { get }
    var timeout: TimeInterval { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var encoding: ParameterEncoding { get }
    
    var responseHandlers: [ResponseHandler] { get }
    
    func complete(_ response: TransportResponse)
}

extension Request {
    public var cachePolicy: URLRequest.CachePolicy {
        return URLRequest.CachePolicy.reloadIgnoringLocalCacheData
    }
}

public class TransportRequest: Request {
    public var responseHandlers: [ResponseHandler] = []
    
    public var path: String = ""
    
    public var method: HttpMethod = .POST
    
    public var parmeter: [String : Any] = [:]
    
    public var timeout: TimeInterval = 20
    
    public var encoding: ParameterEncoding = URLEncoding.default
    
    init(path: String, params: [String: Any]) {
        self.path = path
        self.parmeter = params
    }
    
    public func complete(_ response: TransportResponse) {
        if let contentType = response.headers["Content-Type"] as? String,
            contentType == "application/json" {
        }
        for handler in self.responseHandlers {
            handler(response)
        }
    }
}

public enum ResponseData {
    case none
    case jsonDict(AnyObject)
}

public class TransportResponse {
    var httpStatusCode: Int
    var headers: [AnyHashable: Any]
    var sessionError: Error?
    
    var payload: ResponseData
    
    static func response(with error: Error) -> TransportResponse {
        return TransportResponse.init(payload: .none,
                                      httpStatus: 0,
                                      sessionError: error,
                                      headers: [:])
    }
    
    static func response(with response: HTTPURLResponse, data: Data?) -> TransportResponse {
        let statusCode = response.statusCode
        let headers = response.allHeaderFields
        guard let respData = data else {
            return TransportResponse.init(payload: .none,
                                          httpStatus: statusCode,
                                          sessionError: nil,
                                          headers: headers)
        }
        do {
            let json = try JSONSerialization.jsonObject(with: respData, options: [.allowFragments])
            return TransportResponse.init(payload: .jsonDict(json as AnyObject),
                                          httpStatus: statusCode,
                                          sessionError: nil,
                                          headers: headers)
        } catch {
            return TransportResponse.init(payload: .none,
                                          httpStatus: statusCode,
                                          sessionError: error,
                                          headers: headers)
        }
    }
    
    private init(payload: ResponseData,
                 httpStatus: Int,
                 sessionError: Error?,
                 headers: [AnyHashable: Any]) {
        self.payload = payload
        self.httpStatusCode = httpStatus
        self.sessionError = sessionError
        self.headers = headers
    }
}
