//
//  AudioRecord.swift
//  WaveDemo
//
//  Created by mac on 2017/8/11.
//  Copyright © 2017年 yolande. All rights reserved.
//

import UIKit
import AVFoundation
import Accelerate

protocol AudioRecordPortocol: NSObjectProtocol {
    func record(_ record: AudioRecord, voluem: Float)
}

class AudioRecord {
    static func getNewRecordPath() -> String {
        if let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first {
            let date = Date.init()
            let dformmatter = DateFormatter.init()
            dformmatter.dateFormat = "yyyyMMddhhmmss_01"
            let s = dformmatter.string(from: date)
            let path = "\(documentPath)/\(s).caf"// 如果需要改变格式，需要改变录音格式
            return path
        }
        return ""
    }
    
    private let filePath: String = AudioRecord.getNewRecordPath()
    
    public static let shared = AudioRecord()
    public weak var delegate: AudioRecordPortocol?
    
    private static let bufSize: Int = 4096
    private let bus: Int = 0
    
    private var engine: AVAudioEngine
    private var inputNode: AVAudioNode
    private var mixNode: AVAudioMixerNode
    private var reverd: AVAudioUnitReverb = AVAudioUnitReverb.init() // 添加效果
    
    private var lame: lame_t?
    
    private var mp3Buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufSize)
    
    private var averagePowerForChannel0: Float = 0.0
    private var averagePowerForChannel1: Float = 0.0
    
    private var minLevel: Float = 0.0
    private var maxLevel: Float = 0.0
    
    init() {
        engine = AVAudioEngine()
        inputNode = engine.inputNode
        mixNode = AVAudioMixerNode.init()
        self.bindNodes(from: inputNode, to: reverd)
        self.bindNodes(from: reverd, to: mixNode)
        reverd.wetDryMix = 100
        reverd.loadFactoryPreset(.largeRoom)
        engine.attach(reverd)
        engine.attach(mixNode)
    }
    
    deinit {
        mp3Buffer.deallocate()
    }
    
    public func record() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord)
            try session.setPreferredSampleRate(44100)
            try session.setPreferredIOBufferDuration(0.1)
            try session.setActive(true)
            initLame()
        } catch {
            print("seesion设置")
            return
        }
        
        let input = mixNode
        
        let format = input.inputFormat(forBus: 0)
        input.installTap(onBus: 0, bufferSize:AVAudioFrameCount(AudioRecord.bufSize) , format: format) { [weak self] (buffer, when) in
            
            guard let this = self else { return }
            if let buf = buffer.floatChannelData?[0] {
                let frameLength = Int32(buffer.frameLength) / 2
                let bytes = lame_encode_buffer_interleaved_ieee_float(this.lame, buf, frameLength, this.mp3Buffer, Int32(AudioRecord.bufSize))
                
                let levelLowpassTrig: Float = 0.5
                var avgValue: Float32 = 0
                vDSP_meamgv(buf, 1, &avgValue, vDSP_Length(frameLength))
                this.averagePowerForChannel0 = (levelLowpassTrig * ((avgValue==0) ? -100 : 20.0 * log10f(avgValue))) + ((1-levelLowpassTrig) * this.averagePowerForChannel0)
                
                let volume = min((this.averagePowerForChannel0 + Float(55))/55.0, 1.0)
                
                this.minLevel = min(this.minLevel, volume)
                this.maxLevel = max(this.maxLevel, volume)
                // 切回去, 更新UI
                DispatchQueue.main.async {
                    this.delegate?.record(this, voluem: volume)
                }
                guard bytes > 0, let weakSelf = self else { return }
                let data = Data.init(bytes: this.mp3Buffer, count: Int(bytes))
                if FileManager.default.fileExists(atPath: weakSelf.filePath) == false {
                    FileManager.default.createFile(atPath: weakSelf.filePath, contents: nil, attributes: nil)
                }
                if let handle = try? FileHandle.init(forUpdating: URL(fileURLWithPath: weakSelf.filePath)) {
                    handle.seekToEndOfFile()
                    handle.write(data)
                }
            }
        }
        
        engine.prepare()
        do {
            try engine.start()
        } catch {
            print("engine启动")
        }
    }
    
    private func bindNodes(from inputNode: AVAudioNode, to node: AVAudioNode) {
        let format = inputNode.inputFormat(forBus: self.bus)
        engine.connect(inputNode, to: node, format: format)
    }
    
    private func unbindNodes(from node: AVAudioNode) {
        engine.disconnectNodeInput(node)
    }
    
    private func initLame() {
        let input = engine.inputNode
        let format = input.inputFormat(forBus: self.bus)
        let sampleRate = Int32(format.sampleRate) / 2
        
        lame = lame_init()
        lame_set_in_samplerate(lame, sampleRate);
        lame_set_VBR_mean_bitrate_kbps(lame, 96);
        lame_set_VBR(lame, vbr_off);
        lame_init_params(lame);
    }
    
    public func stop() {
        print("min: \(self.minLevel)")
        print("max: \(self.maxLevel)")
        engine.inputNode.removeTap(onBus: self.bus)
    }
}
