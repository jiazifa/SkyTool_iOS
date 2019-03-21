//
//  DebugOption.swift
//  HuBeiECarSalerClient
//
//  Created by tree on 2018/12/23.
//  Copyright © 2018 tree. All rights reserved.
//

import Foundation

/**
 Available settings
 
 
 - DarkMode:               Dark mode for conversation
 */
public enum SettingsPropertyName: String, CustomStringConvertible {
    
    // User defaults
    case isPushEnabled = "UserDefaultPushDisabled"
    
    public var changeNotificationName: String {
        return self.description + "ChangeNotification"
    }
    
    public var description: String {
        return self.rawValue
    }
}
