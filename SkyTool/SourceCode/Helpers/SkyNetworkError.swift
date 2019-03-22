//
//  SkyNetworkError.swift
//  SkyTool
//
//  Created by tree on 2019/3/19.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

public enum SkyNetworkError: Error {
    
    public enum RequestErrorReason {
        /// The `URL` object is missing while encoding a request.
        case missingURL
        /// The request requires an access token but it is unavailable. Code 40204.
        case expiredAccessToken
        /// The request requires a JSON body but the provided data cannot be encoded to valid JSON.
        case jsonEncodingFailed(Error)
        /// 缺少参数 code 40000.
        case missingArgs
    }
    
    public enum ResponseErrorReason {
        public struct APIErrorDetail {
            let code: Int
            let raw: HTTPURLResponse
            let rawString: String?
        }
        case URLSessionError(Error)
        case nonHTTPURLResponse
        case dataParsingFailed(Any.Type, Data, Error)
        case invalidHTTPStatusAPIError(detail: APIErrorDetail)
    }
    case requestFailed(reason: RequestErrorReason)
    case responseFailed(reason: ResponseErrorReason)
}
