//
//  HomeController.swift
//  SkyTool
//
//  Created by tree on 2019/3/21.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit
import AVFoundation

class HomeController {
    
    let viewController: UIViewController
    
    let recorder = Recorder()
    
    init(sourceController: UIViewController) {
        self.viewController = sourceController
    }
    
    @objc(addButtonClicked:)
    func onAddClicked(_ sender: UIControl) {
        self.checkPermissionAndRecord()
    }
    
    @objc func onItemClicked(_ index: Int) {
        guard let htmlPath = Bundle.main.path(forResource: "index", ofType: "html", inDirectory: "vexflow") else { return }
        let url = URL(fileURLWithPath: htmlPath)
        let webViewController = MusicWebViewController.init(url)
        webViewController.title = "网页"
        let c = Note.init(letter: .C, octave: 4)
        let e = Note.init(letter: .E, octave: 4)
        let g = Note.init(letter: .G, octave: 4)
        let group: [StaveNote] = [ // 小节
            StaveNote.init(notes: [c, e, g], isDot: false, duration: .quater),
            StaveNote.init(notes: [c, e, g], isDot: false, duration: .quater),
            StaveNote.init(notes: [e, g], isDot: false, duration: .quater),
            StaveNote.init(notes: [e, g], isDot: false, duration: .quater),
            ]
        let groups = [group, group]
        webViewController.render(groups)
        webViewController.isHideProcess = true
        viewController.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func toOpenSheet() {
        if let url = URL(string: "https://opensheetmusicdisplay.github.io/demo/") {
            let webViewController = WebViewController.init(url)
            self.viewController.navigationController?.pushViewController(webViewController, animated: true)
        }
    }
    
    public func checkPermissionAndRecord() {
        let session = AVAudioSession.sharedInstance()
        do {
            if #available(iOS 10.0, *) {
                try session.setCategory(.playAndRecord, mode: .default, options: [])
            }
            try session.setActive(true)
            session.requestRecordPermission({ [weak self] (allowed) in
                DispatchQueue.main.async {
                    if allowed == false {
                        if ((Double.init(UIDevice.current.systemVersion) ?? 0.0) > 10.0) {
                            if let url = URL.init(string: UIApplication.openSettingsURLString) {
                                if UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            }
                        }
                    }else {
                        try? self?.recorder.start()
                    }
                }
            })
        } catch _ {
            return
        }
    }
}
