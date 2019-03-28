//
//  HomeController.swift
//  SkyTool
//
//  Created by tree on 2019/3/21.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

class HomeController {
    
    let viewController: UIViewController
    
    init(sourceController: UIViewController) {
        self.viewController = sourceController
    }
    
    @objc(addButtonClicked:)
    func onAddClicked(_ sender: UIControl) {
        
    }
    
    @objc func onItemClicked(_ index: Int) {
        guard let bundlePath = Bundle.main.path(forResource: "music_notation", ofType: "bundle"),
            let bundle = Bundle.init(path: bundlePath),
            let htmlPath = bundle.path(forResource: "index", ofType: "html") else { return }
        let url = URL(fileURLWithPath: htmlPath)
        let webViewController = MusicWebViewController.init(url)
        webViewController.title = "网页"
//        webViewController.render("Q=treble T=4/4 K=F C4/4 Cx4/8 Eb4/8 ' F4/8 AB4/8 ' Ab4/4 | Eb4/8 D4/8^ ' D4/8 C4/8 ' Ab3/8 Eb3+G3+C4/4. \\\\ Q=bass T=4/4 K=F Eb3+G3/2 C3/2 | F#2/2^ F#2/8 C2/4.")
        webViewController.isHideProcess = true
        viewController.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func toOpenSheet() {
        if let url = URL(string: "https://opensheetmusicdisplay.github.io/demo/") {
            let webViewController = WebViewController.init(url)
            self.viewController.navigationController?.pushViewController(webViewController, animated: true)
        }
    }
}
