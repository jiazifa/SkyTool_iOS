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
    var commandQueue: [String: Any] = [:]
}

extension MusicWebViewController {
    func callJavascript(_ method: String, args: [String], done: ((String?) -> ())?) {
        let methodCommand = generateCommand(method, args: args)
        self.webView.evaluateJavaScript(methodCommand) { (x, e) in
            if let returnValue = x as? String {
                done?(returnValue)
            }
        }
    }
    
    func generateCommand(_ method: String, args: [String]) -> String {
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
        return methodCommand
    }
    
    func flushCommandsAndRunIfCan(_ command: (String, Any)?) {
        if let (cmd, args) = command {
            self.commandQueue.updateValue(args, forKey: cmd)
        }
        guard self.isWebViewLoaded else { return }
        while !self.commandQueue.isEmpty {
            if let first = self.commandQueue.popFirst() {
                if let value = first.value as? [String] {
                    self.callJavascript(first.key, args: value, done: nil)
                } else if let value = first.value as? String {
                    self.callJavascript(first.key, args: [value], done: nil)
                } else { fatalError() }
            }
        }
    }
    
    public func render(_ notationCommand: String) {
        let command = notationCommand.replacingOccurrences(of: "\\\\", with: "\\")
        self.flushCommandsAndRunIfCan(("renderVexpaString", command))
    }
}

extension MusicWebViewController {
    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        super.webView(webView, didFinish: navigation)
        self.flushCommandsAndRunIfCan(nil)
    }
}
