//
//  WebBridge.swift
//  playground
//
//  Created by tree on 2018/11/1.
//  Copyright © 2018 treee. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import JavaScriptCore

typealias webBridgeRespCallBack = ([String: Any])->(Any)
class WebBridge {
    
    var webView: WKWebView
    
    var callbackpool: [String: webBridgeRespCallBack] = [:]
    
    init(_ webView: WKWebView) {
        self.webView = webView
    }
    
    func injectScript(to webView: WKWebView) {
        guard let path = Bundle.main.path(forResource: "_inject_bridge", ofType: "js"),
            let command = try? String.init(contentsOfFile: path) else { return }
        let userScript = WKUserScript.init(source: command, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        webView.configuration.userContentController.addUserScript(userScript)
        Log.print(webView.configuration.userContentController.userScripts)
    }
    
    func canEvaluate(with url: URL) -> Bool {
        return false
    }
    
    @discardableResult
    func evaluate(url: URL) -> Bool {
        if (url.absoluteString.contains("test")) {
            if let handleId = url.handleId {
                self.getParams(by: handleId) { (params) in
                    self.callJSBlock(handleId: handleId, value: "{k: '恭喜你调用成功了'}")
                }
            }
            return true
        }
        return false
    }
    
    func getParams(by handleId: String, completion: @escaping (Any?) -> Void) {
        let command = "__Native_getParams(\(handleId))"
        webView.evaluateJavaScript(command) { (result, error) in
            completion(result)
        }
    }
    
    func callJSBlock(handleId: String, value: String) {
        let command = "Bridge.postMessage({handler:\(handleId), data: \(value)})"
        Log.print(command)
        self.webView.evaluateJavaScript(command, completionHandler: nil)
    }
}

fileprivate extension URL {
    var handleId: String? {
        return self.queryItems?.first(where: {$0.name == "handler"})?.value
    }
}
