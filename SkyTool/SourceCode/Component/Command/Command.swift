//
//  Command.swift
//  pandaMaMa
//
//  Created by tree on 2017/8/15.
//  Copyright © 2017年 tree. All rights reserved.
//

import Foundation

public protocol CommandType: class {
    
    var identifier: UUID { get }
    
    var delegate: CommandDelegate? {get set}
    
    func execute()
}

func == (left: CommandType, right: CommandType) -> Bool {
    return left.identifier == right.identifier
}

public protocol CommandDelegate {
    func commandDidFinish(_ cmd: CommandType) -> Void
    
    func commandDidFailed(_ cmd: CommandType) -> Void
}
