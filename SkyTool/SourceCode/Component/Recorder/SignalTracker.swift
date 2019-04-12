//
//  SignalTracker.swift
//  SkyTool
//
//  Created by tree on 2019/4/12.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import AVFoundation

public protocol SignalTrackerDelegate: class {
    func signalTracker(_ signalTracker: SignalTracker,
                       didReceiveBuffer buffer: AVAudioPCMBuffer,
                       atTime time: AVAudioTime)
    func signalTrackerWentBelowLevelThreshold(_ signalTracker: SignalTracker)
}

public enum SignalTrackerMode {
    case record, playback
}

public protocol SignalTracker: class {
    var mode: SignalTrackerMode { get }
    var levelThreshold: Float? { get set }
    var peakLevel: Float? { get }
    var averageLevel: Float? { get }
    var delegate: SignalTrackerDelegate? { get set }
    
    func start() throws
    func stop()
}

extension AVAudioPCMBuffer {
    func toData() -> Data? {
        let channelCount = 1  // given PCMBuffer channel count is 1
        if let data = self.floatChannelData {
            let length: Int = Int(self.frameCapacity * self.format.streamDescription.pointee.mBytesPerFrame)
            let channels = UnsafeBufferPointer(start: data, count: channelCount)
            let ch0Data = NSData(bytes: channels[0],
                                 length: length) as Data
            return ch0Data
        }
        return nil
    }
}
