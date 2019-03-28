//
//  WebViewController.swift
//  GrillNowiOS
//
//  Created by tree on 2018/12/5.
//  Copyright © 2018 tree. All rights reserved.
//

import UIKit
import WebKit
import PureLayout

class WebViewController: UIViewController {
    
    public var isHideProcess: Bool = false
    
    public private(set) var isWebViewLoaded: Bool = false
    
    @objc internal let webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration.init()
        // preferences
        let p = WKPreferences.init()
        p.minimumFontSize = 10
        p.javaScriptEnabled = true
        p.javaScriptCanOpenWindowsAutomatically = false
        webConfiguration.preferences = p
        let o = WKWebView.init(frame: CGRect.zero, configuration: webConfiguration)
        return o
    }()
    
    private let contentController: WKUserContentController = {
        let o = WKUserContentController.init()
        return o
    }()
    
    // 初始化url
    public private(set) var url: URL
    
    private lazy var backButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.bounds = CGRect.init(x: 0, y: 0, width: 25, height: 30)
        button.setImage(UIImage.init(named: "black_back"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()
    
    private lazy var progressView: UIProgressView = {
        let o = UIProgressView.init()
        o.trackTintColor = UIColor.white
        o.progressTintColor = UIColor.blue
        o.isHidden = self.isHideProcess
        o.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        return o
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.webView)
        self.view.addSubview(self.progressView)
        self.webView.autoPinEdgesToSuperviewEdges()
        
        self.progressView.autoPinEdge(toSuperviewEdge: .top)
        self.progressView.autoPinEdge(toSuperviewEdge: .left)
        self.progressView.autoPinEdge(toSuperviewEdge: .right)
        self.progressView.autoSetDimension(.height, toSize: 2.0)
        
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.loadURLIfNeeded(url)
        self.setupProgressView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
//        self.navigationController?.navigationBar.barTintColor = UIColor.white
//        self.navigationController?.navigationBar.tintColor = UIColor.white
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: self.backButton)
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setupProgressView() {
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath ==  "estimatedProgress" {
            guard let info = change,
                let newValue = info[.newKey],
                let progress = newValue as? Double else { return }
            self.progressView.isHidden = self.isHideProcess
            self.progressView.progress = Float(progress)
            if self.progressView.progress >= Float(1.0) {
                self.hideProgressView()
            }
        }
    }
    
    private func hideProgressView() {
        UIView.animate(withDuration: 0.25,
                       delay: 0.3, options: [.curveEaseOut],
                       animations: {
                        self.progressView.transform = .init(scaleX: 1.0, y: 1.4)
        }, completion: { (comp) in
            self.progressView.isHidden = comp
        })
    }
    
    func loadURLIfNeeded(_ url: URL) {
        if url.isFileURL {
            if #available(iOS 9.0, *) {
                self.webView.loadFileURL(url, allowingReadAccessTo: url)
            } else {
                self.webView.load(URLRequest.init(url: url))
            }
        } else {
            self.webView.load(URLRequest.init(url: url))
        }
    }
    
    @objc(initWithURL:)
    required init(_ url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WebViewController: WKNavigationDelegate {
    // MARK: 加载前判断是否需要加载
    // 是否允许跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard navigationAction.request.url != nil else {
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
    
    // MARK: 下载指定内容的回调
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    // MARK: 下载后载入视图
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.isWebViewLoaded = true
        if self.title == nil {
            self.title = webView.title
        }
    }
    
    // 失败
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.progressView.isHidden = true
    }
}

extension WebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        guard let target = navigationAction.targetFrame else {return nil }
        if target.isMainFrame {
            webView.load(target.request)
        }
        return nil
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        self.close()
    }
    
    // 显示确认按钮
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: { (_) -> Void in
            completionHandler(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = defaultText
        }
        alert.addAction(UIAlertAction(title: "完成", style: .default, handler: { (_) -> Void in
            if let textField = alert.textFields?.first {
                completionHandler(textField.text ?? "")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension WebViewController {
    func close() {
        if let navigation = self.navigationController {
            navigation.popViewController(animated: true)
        } else if self.presentingViewController != nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func goBack() {
        if self.webView.canGoBack {
            self.webView.goBack()
        } else {
            self.close()
        }
    }
}
