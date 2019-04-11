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
        guard let htmlPath = Bundle.main.path(forResource: "index", ofType: "html", inDirectory: "vexflow") else { return }
        let url = URL(fileURLWithPath: htmlPath)
        let webViewController = MusicWebViewController.init(url)
        webViewController.title = "网页"
        var notes = [[[String: Any]]]()
        let n = Note.init(letter: .C, octave: 4)
        notes.append([
            ["keys": ["\(n)"],
             "duration": "q",
             "clef": "treble"],
            ["keys": ["d/4"],
             "duration": "q"]
            ])
        
        webViewController.render(notes)
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
