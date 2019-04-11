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
    var commandQueue: [String: Any?] = [:]
}

extension MusicWebViewController {
    func callJavascript(_ command: String, done: ((String?) -> ())?) {
        self.webView.evaluateJavaScript(command) { (x, e) in
            if let returnValue = x as? String {
                done?(returnValue)
            }
        }
    }
    
    func generateCommand(_ method: String, args: Any?=nil) throws -> String {
        var methodCommand = method
        methodCommand += "("
        if let args = args {
            do {
                let commandData = try JSONSerialization.data(withJSONObject: args, options: [])
                if let cmdString = String.init(data: commandData, encoding: .utf8) {
                    let newCommand = cmdString.replacingOccurrences(of: "\"", with: "\\\"")
                    methodCommand += "\""
                    methodCommand += newCommand
                    methodCommand += "\""
                }
            }catch {
                throw error
            }
        }
//        _ = methodCommand.removeLast()
        methodCommand += ")"
        Log.print("\(methodCommand)")
        return methodCommand
    }
    
    func flushCommandsAndRunIfCan(_ command: (String, Any?)?) {
        if let (cmd, args) = command {
            self.commandQueue.updateValue(args, forKey: cmd)
        }
        guard self.isWebViewLoaded else { return }
        while self.commandQueue.isEmpty == false {
            if let first = self.commandQueue.popFirst() {
                if let commandString = try? generateCommand(first.key, args: first.value) {
                    self.callJavascript(commandString, done: nil)
                } else { fatalError() }
            }
        }
    }
    
    public func render(_ notes: [StaveNote]) {
        var staveNotes = [[String: Any]]()
        for n in notes {
            var params = [String: Any]()
            var nn: [String] = []
            for subn in n.notes {
                nn.append(subn.description)
            } // keys
            params.updateValue(nn, forKey: "keys")
            params.updateValue(n.isDot, forKey: "addDot")
            params.updateValue(n.duration.vexflowDescription, forKey: "duration")
            staveNotes.append(params)
        } // note
        self.flushCommandsAndRunIfCan(("renderVex", [staveNotes]))
    }
}

extension MusicWebViewController {
    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        super.webView(webView, didFinish: navigation)
        self.flushCommandsAndRunIfCan(nil)
    }
}
