//
// Wire
// Copyright (C) 2016 Wire Swiss GmbH
// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//

import Foundation
import UIKit

enum SettingsPropertyError: Error {
    case WrongValue(String)
}

protocol SettingsPropertyFactoryDelegate: class {
    func asyncMethodDidStart(_ settingsPropertyFactory: SettingsPropertyFactory)
    func asyncMethodDidComplete(_ settingsPropertyFactory: SettingsPropertyFactory)
}

class SettingsPropertyFactory {
    let userDefaults: UserDefaults
    weak var delegate: SettingsPropertyFactoryDelegate?
    
    static let userDefaultsPropertiesToKeys: [SettingsPropertyName: String] = [
        SettingsPropertyName.isPushEnabled: UserDefaultPushDisabled
    ]
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func property(_ propertyName: SettingsPropertyName) -> SettingsProperty {
        switch propertyName {
        case .isPushEnabled:
            let getAction: GetAction = { (property: SettingsBlockProperty) -> SettingsPropertyValue in
                return SettingsPropertyValue(Settings.shared.isPushDisable)
            }
            let setAction: SetAction = { (_, value) in
                switch value {
                case .bool(value: let number):
                    Settings.shared.isPushDisable = number
                default:
                    fatalError()
                }
            }
            return SettingsBlockProperty(propertyName: propertyName,
                                         getAction: getAction,
                                         setAction: setAction)
        case .touchuHostAddress:
            let getAction: GetAction = { (property: SettingsBlockProperty) -> SettingsPropertyValue in
                return SettingsPropertyValue.string(value: Settings.shared.touchHostAddress ?? "")
            }
            let setAction: SetAction = { (_, value) in
                switch value {
                case .string(value: let string):
                    Settings.shared.touchHostAddress = string
                default:
                    fatalError()
                }
            }
            return SettingsBlockProperty(propertyName: propertyName,
                                         getAction: getAction,
                                         setAction: setAction)
        }
        
    }
}
