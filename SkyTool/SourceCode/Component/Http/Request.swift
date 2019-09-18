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

protocol ErrorCodeProtocol: Error, CustomStringConvertible {
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
    var description: String { return "" }
    
    case some(Int)
}

enum AuthError: Error, ErrorCodeProtocol {
    
    case accountExsist //  40200
    case noAccount //  40203
    case tokenExpired //  40204
    case needPermission //  43000
    
    var description: String {
        switch self {
        case .accountExsist: return "账号已存在"
        case .noAccount: return "账号不存在"
        case .tokenExpired: return "账号授权过期"
        case .needPermission: return "需要授权"
        }
    }
}

enum SessionCommonError: Error, ErrorCodeProtocol {
    
    case unknown //  9999
    case argsError //  40000
    case toastMessage(String) // 40001 由后台返回的，需要显示内容的
    case resourceNotFound //  44000
    
    var description: String {
        switch self {
        case .unknown: return "未知错误"
        case .argsError: return "参数错误"
        case .toastMessage(let content): return content
        case .resourceNotFound: return "资源不存在"
        }
    }
}

public enum HttpMethod: String {
    case GET
    case POST
}
public protocol TransportResponsePiplineType {
    func translate(response: TransportResponse) -> TransportResponse
}

public typealias ResponseHandler = TransportResponsePiplineType

public protocol Request {
    var path: String { get }
    var method: HttpMethod { get }
    var parmeter: [String: Any] { get }
    var timeout: TimeInterval { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var encoding: ParameterEncoding { get }
    
    var responsePiplines: [ResponseHandler] { get }
    
    func onComplete(_ response: TransportResponse)
}

extension Request {
    public var cachePolicy: URLRequest.CachePolicy {
        return URLRequest.CachePolicy.reloadIgnoringLocalCacheData
    }
}

public class TransportRequest: Request {
    public var responsePiplines: [ResponseHandler] = []
    
    public var path: String = ""
    
    public var method: HttpMethod = .POST
    
    public var parmeter: [String : Any] = [:]
    
    public var timeout: TimeInterval = 20
    
    public var encoding: ParameterEncoding = URLEncoding.default
    
    init(path: String, params: [String: Any]) {
        self.path = path
        self.parmeter = params
    }
    
    public func onComplete(_ response: TransportResponse) {}
}

public struct PageWrapper<T: Codable>: Codable {
    var limit: Int
    var pages: Int
    var total: Int
    var list: [T]
    
    enum CodingKeys: String, CodingKey {
        case limit = "limit"
        case pages = "pages"
        case total = "total"
        case list = "list"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: PageWrapper.CodingKeys.self)
        self.limit = try values.decode(Int.self, forKey: .limit)
        self.pages = try values.decode(Int.self, forKey: .pages)
        self.total = try values.decode(Int.self, forKey: .total)
        self.list = try values.decode([T].self, forKey: .list)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PageWrapper.CodingKeys.self)
        try container.encode(limit, forKey: .limit)
        try container.encode(pages, forKey: .pages)
        try container.encode(total, forKey: .total)
        try container.encode(list, forKey: .list)
        
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
            if let jsonDict = json as? [String: Any] {
                // filter error codes
                var err: Error?
                if let code = jsonDict["code"] as? Int,
                    [200, 201, 202, 204].contains(code) == false {
                    if let msg = jsonDict["msg"] as? String,
                        code == 40001 {
                        err = SessionCommonError.toastMessage(msg)
                    } else {
                        err = SessionErrorCode.errorObject(code: code)
                    }
                }
                // payload
                var payload = ResponseData.jsonDict(jsonDict)
                if let dataInJSON = jsonDict["data"] as? [String: Any] {
                    payload = ResponseData.jsonDict(dataInJSON)
                } else if let dataInArray = jsonDict["data"] as? [Any] {
                    payload = ResponseData.jsonArray(dataInArray)
                }
                
                return TransportResponse.init(payload: payload,
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
