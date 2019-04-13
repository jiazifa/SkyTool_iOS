//
//  CommandManager.swift
//  pandaMaMa
//
//  Created by tree on 2017/8/15.
//  Copyright © 2017年 tree. All rights reserved.
//

import Foundation

public class CommandManager {
    
    private(set) var commandQueue: [CommandType] = []
    
    static let shared = CommandManager()
    
    public func execute(_ cmd: CommandType) -> Void {
        self.commandQueue.append(cmd)
        cmd.execute()
    }
    
    public func cancel(_ cmd: CommandType) -> Void {
        Log.print("cancel \(cmd)")
        cmd.delegate?.commandDidFailed(cmd)
        self.commandQueue.removeAll(where: {$0 == cmd})
    }
    
    public func done(_ cmd: CommandType) {
        Log.print("done \(cmd)")
        cmd.delegate?.commandDidFinish(cmd)
        self.commandQueue.removeAll(where: {$0 == cmd})
    }
}
