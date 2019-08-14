//
//  Request.swift
//  SkyTool
//
//  Created by tree on 2019/3/19.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

enum SessionError: Error {
    case none
    case auth(AuthError)
    case common(SessionCommonError)
}

protocol ErrorCodeProtocol: Error {
    static func errorObject(code: Int) -> Error?
}

extension ErrorCodeProtocol {
    static func errorObject(code: Int) -> Error? {
        let all: [Int: ErrorCodeProtocol] = [
            // AuthError
            40200: AuthError.accountExsist,
            40203: AuthError.noAccount,
            40204: AuthError.tokenExpired,
            43000: AuthError.needPermission,
            
            // SessionCommonError
            9999: SessionCommonError.unknown,
            40000: SessionCommonError.argsError,
            44000: SessionCommonError.resourceNotFound,
        ]
        return all.first(where: {$0.key == code})?.value
    }
}

enum SessionErrorCode: ErrorCodeProtocol {
    case some(Int)
}

enum AuthError: Error, ErrorCodeProtocol {
    
    case accountExsist //  40200
    case noAccount //  40203
    case tokenExpired //  40204
    case needPermission //  43000
}

enum SessionCommonError: Error, ErrorCodeProtocol {
    
    case unknown //  9999
    case argsError //  40000
    case resourceNotFound //  44000
}

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
    case jsonDict([String: Any])
    case jsonArray([Any])
    case json(Any)
}

public class TransportResponse {
    var httpStatusCode: Int
    var headers: [AnyHashable: Any]
    var sessionError: Error?
    
    var payload: ResponseData
    
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

public extension TransportResponse {
    
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
            if let jsonArray = json as? [Any] {
                return TransportResponse.init(payload: .jsonArray(jsonArray),
                                              httpStatus: statusCode,
                                              sessionError: nil,
                                              headers: headers)
            } else if let jsonDict = json as? [String: Any] {
                // filter error codes
                var err: Error?
                if let code = jsonDict["code"] as? Int {
                     err = SessionErrorCode.errorObject(code: code)
                }
                return TransportResponse.init(payload: .jsonDict(jsonDict),
                                              httpStatus: statusCode,
                                              sessionError: err,
                                              headers: headers)
            } else {
                return TransportResponse.init(payload: .json(json),
                                              httpStatus: statusCode,
                                              sessionError: nil,
                                              headers: headers)
            }
        } catch {
            return TransportResponse.init(payload: .none,
                                          httpStatus: statusCode,
                                          sessionError: error,
                                          headers: headers)
        }
    }
}
