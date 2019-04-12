//
//  Recorder.swift
//  SkyTool
//
//  Created by tree on 2019/4/12.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

public final class Recorder {
    public enum Error: Swift.Error {
        case recordPermissionDenied
    }
    
    public private(set) var active = false
    
    private let signalTracker: SignalTracker
    private let queue: DispatchQueue
    private let filePath: String
    
    public var mode: SignalTrackerMode {
        return signalTracker.mode
    }
    
    // MARK: - Initialization
    public init() {
        #if arch(i386) || arch(x86_64)
        self.signalTracker = SimulatorSignalTracker.init(delegate: nil, frequencies: nil, delayMs: 10)
        #else
        self.signalTracker = InputSignalTracker.init(bufferSize: 1024, delegate: nil)
        #endif
        
        self.queue = DispatchQueue(label: "BeethovenQueue", attributes: [])
        self.filePath = Recorder.getNewRecordPath()
        self.signalTracker.delegate = self
    }
    
    static func getNewRecordPath() -> String {
        if let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first {
            let date = Date.init()
            let dformmatter = DateFormatter.init()
            dformmatter.dateFormat = "yyyyMMddhhmmss"
            let s = dformmatter.string(from: date)
            let path = "\(documentPath)/\(s).caf"// 如果需要改变格式，需要改变录音格式
            return path
        }
        return ""
    }
    
    // MARK: - Processing
    public func start() {
        guard mode == .playback else {
            activate()
            return
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        
        switch audioSession.recordPermission {
        case AVAudioSession.RecordPermission.granted:
            activate()
        case AVAudioSession.RecordPermission.denied:
            DispatchQueue.main.async {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            }
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted  in
                guard let weakSelf = self else { return }
                
                guard granted else {
                    
                    return
                }
                
                DispatchQueue.main.async {
                    weakSelf.activate()
                }
            }
        }
    }
    
    public func stop() {
        signalTracker.stop()
        active = false
    }
    
    func activate() {
        do {
            try signalTracker.start()
            active = true
        } catch {
            Log.print("\(error)")
        }
    }
}

// MARK: - SignalTrackingDelegate
extension Recorder: SignalTrackerDelegate {
    public func signalTracker(_ signalTracker: SignalTracker,
                              didReceiveBuffer buffer: AVAudioPCMBuffer,
                              atTime time: AVAudioTime) {
        queue.async { [weak self] in
            
            Log.print("收到回调\(buffer.floatChannelData)")
            guard let `self` = self,
                let data = buffer.toData() else { return }
            if FileManager.default.fileExists(atPath: self.filePath) == false {
                FileManager.default.createFile(atPath: self.filePath, contents: nil, attributes: nil)
            }
            if let handle = try? FileHandle.init(forUpdating: URL(fileURLWithPath: self.filePath)) {
                handle.seekToEndOfFile()
                handle.write(data)
            }
        }
    }
    
    public func signalTrackerWentBelowLevelThreshold(_ signalTracker: SignalTracker) {
        DispatchQueue.main.async {
            
        }
    }
}
