//
//  SettingsProperty.swift
//  HuBeiECarSalerClient
//
//  Created by tree on 2018/12/28.
//  Copyright © 2018 tree. All rights reserved.
//

import UIKit

enum SettingsPropertyValue: Equatable {
    case bool(value: Bool)
    case number(value: NSNumber)
    case string(value: String)
    case none
    
    init(_ bool: Bool) {
        self = .bool(value: bool)
    }
    
    init(_ uint: UInt) {
        self = .number(value: NSNumber(value: uint))
    }
    
    init(_ int: Int) {
        self = .number(value: NSNumber(value: int))
    }
    
    init(_ int: Int16) {
        self = .number(value: NSNumber(value: int))
    }
    
    init(_ int: UInt32) {
        self = .number(value: NSNumber(value: int))
    }
    
    static func propertyValue(_ object: Any?) -> SettingsPropertyValue {
        // swiftlint:disable control_statement
        switch(object) {
        case let number as NSNumber:
            return SettingsPropertyValue.number(value: number)
            
        case let stringValue as Swift.String:
            return SettingsPropertyValue.string(value: stringValue)
        
        case let boolValue as Bool:
            return SettingsPropertyValue.bool(value: boolValue)

        default:
            return .none
        }
    }
    
    func value() -> Any? {
        switch (self) {
        case .number(let value):
            return value as AnyObject?
        case .string(let value):
            return value as AnyObject?
        case .bool(let value):
            return value as AnyObject?
        case .none:
            return .none
        }
        // swiftlint:enable control_statement
    }
}

/**
 *  Generic settings property
 */
protocol SettingsProperty {
    var propertyName: SettingsPropertyName { get }
    func value() -> SettingsPropertyValue
    func set(newValue: SettingsPropertyValue) throws
}

extension SettingsProperty {
    internal func rawValue() -> Any? {
        return self.value().value()
    }
}

/**
 Set value to property
 
 - parameter property: Property to set the value on
 - parameter expr:     Property value (raw)
 */
func << (property: inout SettingsProperty, expr: @autoclosure () -> Any) throws {
    let value = expr()
    
    try property.set(newValue: SettingsPropertyValue.propertyValue(value))
}

/**
 Set value to property
 
 - parameter property: Property to set the value on
 - parameter expr:     Property value
 */
func << (property: inout SettingsProperty, expr: @autoclosure () -> SettingsPropertyValue) throws {
    let value = expr()
    
    try property.set(newValue: value)
}

/**
 Read value from property
 
 - parameter value:    Value to assign
 - parameter property: Property to read the value from
 */
func << (value: inout Any?, property: SettingsProperty) {
    value = property.rawValue()
}

/// Generic user defaults property
class SettingsUserDefaultsProperty: SettingsProperty {
    func set(newValue: SettingsPropertyValue) throws {
        self.userDefaults.set(newValue.value(), forKey: self.userDefaultsKey)
        let name = Notification.Name(rawValue: propertyName.changeNotificationName)
        NotificationCenter.default.post(name: name,
                                        object: self)
    }
    
    internal func value() -> SettingsPropertyValue {
        switch self.userDefaults.object(forKey: self.userDefaultsKey) as AnyObject? {
        case let numberValue as NSNumber:
            return SettingsPropertyValue.propertyValue(numberValue.intValue as AnyObject?)
        case let stringValue as String:
            return SettingsPropertyValue.propertyValue(stringValue as AnyObject?)
        default:
            return .none
        }
    }
    
    let propertyName: SettingsPropertyName
    let userDefaults: UserDefaults
    
    let userDefaultsKey: String
    
    init(propertyName: SettingsPropertyName, userDefaultsKey: String, userDefaults: UserDefaults) {
        self.propertyName = propertyName
        self.userDefaultsKey = userDefaultsKey
        self.userDefaults = userDefaults
    }
}

typealias GetAction = (SettingsBlockProperty) -> SettingsPropertyValue
typealias SetAction = (SettingsBlockProperty, SettingsPropertyValue) throws -> Void

/// Genetic block property
open class SettingsBlockProperty: SettingsProperty {
    let propertyName: SettingsPropertyName
    func value() -> SettingsPropertyValue {
        return self.getAction(self)
    }
    
    func set(newValue: SettingsPropertyValue) throws {
        try self.setAction(self, newValue)
        let name = Notification.Name(rawValue: propertyName.changeNotificationName)
        NotificationCenter.default.post(name: name,
                                        object: self)
    }
    
    fileprivate let getAction: GetAction
    fileprivate let setAction: SetAction
    
    init(propertyName: SettingsPropertyName, getAction: @escaping GetAction, setAction: @escaping SetAction) {
        self.propertyName = propertyName
        self.getAction = getAction
        self.setAction = setAction
    }
}
