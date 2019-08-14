//
//  NotifyMessage.swift
//  SkyTool
//
//  Created by tree on 2019/8/14.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit
import Foundation

public enum NotifyLevel {
    case info
    case warning
    case error
}

extension NotifyLevel {
    var backgroundColor: UIColor {
        switch self {
        case .info: return .white
        case .warning: return .yellow
        case .error: return .red
        }
    }
}

public enum NotifyType {
    case toast
    case dropDown
}

extension NotifyType {
    var titleColor: UIColor {
        switch self {
        case .toast: return .white
        case .dropDown: return .white
        }
    }
}

/// 通知消息结构体
public struct NotifyMessage {
    
    /// 等级
    var level: NotifyLevel
    
    /// 方式
    var type: NotifyType
    
    /// 内容
    var content: String
    
    init(level: NotifyLevel, type: NotifyType, content: String) {
        self.level = level
        self.type = type
        self.content = content
    }
    
    static func infoToast(content: String) -> NotifyMessage {
        return NotifyMessage.init(level: .info, type: .toast, content: content)
    }
    
    static func infoDropDown(content: String) -> NotifyMessage {
        return NotifyMessage.init(level: .info, type: .dropDown, content: content)
    }
    
    static func warningDropDown(content: String) -> NotifyMessage {
        return NotifyMessage.init(level: .warning, type: .dropDown, content: content)
    }
    
    static func errorDropDown(content: String) -> NotifyMessage {
        return NotifyMessage.init(level: .error, type: .dropDown, content: content)
    }
}
