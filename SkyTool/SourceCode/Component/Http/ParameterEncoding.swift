//
//  ParameterEncoding.swift
//  SkyTool
//
//  Created by tree on 2019/3/20.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

/// protocol of parameter encoding
public protocol ParameterEncoding {
    func encode(_ urlRequest: URLRequest, with parameters: [String: Any]?) throws -> URLRequest
}

/// URL Encoding, encoding by appending url
public struct URLEncoding: ParameterEncoding {
    public  enum Destination {
        case methodDependent, queryString, httpBody
    }
    
    public static var `default`: URLEncoding { return URLEncoding() }
    
    public static var methodDependent: URLEncoding { return URLEncoding() }
    
    public static var queryString: URLEncoding { return URLEncoding(destination: .queryString) }
    
    public static var httpBody: URLEncoding { return URLEncoding(destination: .httpBody) }
    
    public let destination: URLEncoding.Destination
    
    init(destination: URLEncoding.Destination = .methodDependent) {
        self.destination = destination
    }
    
    public func encode(_ urlRequest: URLRequest, with parameters: [String : Any]?) throws -> URLRequest {
        var urlRequest = urlRequest
        guard let parameters = parameters else { return urlRequest }
        if let method = HttpMethod.init(rawValue: urlRequest.httpMethod ?? "GET"),
            encodesParametersInURL(with: method) {
            guard let url = urlRequest.url else {
                throw SkyNetworkError.requestFailed(reason: SkyNetworkError.RequestErrorReason.missingURL)
            }
            if var urlComponents =  URLComponents(url: url, resolvingAgainstBaseURL: false),
                !parameters.isEmpty {
                let percentEncodedQuery = (urlComponents.percentEncodedQuery.map {$0 + "&"} ?? "") + query(parameters)
                urlComponents.percentEncodedQuery = percentEncodedQuery
                urlRequest.url = urlComponents.url
            }
        } else {
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8",
                                    forHTTPHeaderField: "Content-Type")
            }
            urlRequest.httpBody = query(parameters).data(using: .utf8, allowLossyConversion: false)
        }
        return urlRequest
    }
    
    func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((escape(key), escape(value.boolValue ? "1" : "0")))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let value = value as? Bool {
            components.append((escape(key), escape(value ? "1" : "0")))
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        return components
    }
    
    func escape(_ string: String) -> String {
        var escaped = ""
        let allowedCharacterSet = CharacterSet.urlQueryValueAllowed
        escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        return escaped
    }
    
    func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    func encodesParametersInURL(with method: HttpMethod) -> Bool {
        switch destination {
        case .queryString:
            return true
        case .httpBody:
            return false
        default:
            break
        }
        switch method {
        case .GET:
            return true
        default:
            return false
        }
    }
}

extension NSNumber {
    fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

/// Encoding to json, appending to httpBody
public struct JSONEncoding: ParameterEncoding {
    
    public static var `default`: JSONEncoding { return JSONEncoding() }
    
    public static var prettyPrinted: JSONEncoding { return JSONEncoding(options: .prettyPrinted) }
    
    public let options: JSONSerialization.WritingOptions
    
    init(options: JSONSerialization.WritingOptions = []) {
        self.options = options
    }
    
    public func encode(_ urlRequest: URLRequest, with parameters: [String : Any]?) throws -> URLRequest {
        var urlRequest = urlRequest
        
        guard let parameters = parameters else { return urlRequest }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: self.options)
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            urlRequest.httpBody = data
        } catch {
            throw SkyNetworkError.requestFailed(reason: .jsonEncodingFailed(error))
        }
        return urlRequest
    }
    
}
