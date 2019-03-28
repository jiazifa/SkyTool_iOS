//
//  MusicWebViewController.swift
//  SkyTool
//
//  Created by tree on 2019/3/28.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit
import WebKit

class MusicWebViewController: WebViewController {
    var commandQueue: [String] = []
    
}

extension MusicWebViewController {
    func callJavascript(_ method: String, args: [String], done: ((String?) -> ())?) {
        var methodCommand = method
        methodCommand += "("
        for arg in args {
            methodCommand += "\""
            methodCommand += arg.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            methodCommand += "\""
            methodCommand += ","
        }
        _ = methodCommand.removeLast()
        methodCommand += ")"
        Log.print("\(methodCommand)")
        self.webView.evaluateJavaScript(methodCommand) { (x, e) in
            if let returnValue = x as? String {
                done?(returnValue)
            }
        }
    }
    
    public func render(_ notationCommand: String) {
        let command = notationCommand.replacingOccurrences(of: "\\\\", with: "\\")
        self.callJavascript("renderVexpaString", args: [command], done: nil)
    }
}

extension MusicWebViewController {
    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        super.webView(webView, didFinish: navigation)
        self.render("8. 16 ' 8 16 16 ' \\\\ 16 16 8 ' 16 8.")
    }
}
