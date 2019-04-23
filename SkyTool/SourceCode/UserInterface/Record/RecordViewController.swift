//
//  RecordViewController.swift
//  SkyTool
//
//  Created by tree on 2019/4/23.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {

    var recorder = AudioRecord.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func beginButtonClicked(_ sender: Any) {
        recorder.record()
    }

    @IBAction func playButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func stopButtonClicked(_ sender: Any) {
        recorder.stop()
    }
}
