//
//  SettingsPropertyToggleCellDescriptor.swift
//  HuBeiECarSalerClient
//
//  Created by tree on 2019/1/2.
//  Copyright © 2019 tree. All rights reserved.
//

import UIKit

class SettingsPropertyToggleCellDescriptor: SettingsPropertyCellDescriptorType {
    let inverse: Bool
    
    var settingsProperty: SettingsProperty
    
    static var cellType: SettingsTableCell.Type = SettingsToggleCell.self
    
    var visible: Bool = true
    
    var title: String {
        return SettingsPropertyLabelText(self.settingsProperty.propertyName)
    }
    
    var identifier: String?
    
    var group: SettingsGroupCellDescriptorType?
    
    init(settingsProperty: SettingsProperty, inverse: Bool = false, identifier: String? = .none) {
        self.settingsProperty = settingsProperty
        self.inverse = inverse
        self.identifier = identifier
    }
    
    func featureCell(_ cell: SettingsCellType) {
        cell.titleText = self.title
        cell.titleColor = UIColor.textBlack
        
        if let toggleCell = cell as? SettingsToggleCell {
            var boolValue = false
            if let value = self.settingsProperty.value().value() as? NSNumber {
                boolValue = value.boolValue
            } else {
                boolValue = false
            }
            
            if self.inverse {
                boolValue = !boolValue
            }
            
            toggleCell.switchView.isOn = boolValue
            toggleCell.switchView.accessibilityLabel = identifier
        }
    }
    
    func select(_ value: SettingsPropertyValue) {
        var valueToSet = false
        
        if let value = value.value() {
            switch value {
            case let numberValue as NSNumber:
                valueToSet = numberValue.boolValue
            case let intValue as Int:
                valueToSet = intValue > 0
            case let boolValue as Bool:
                valueToSet = boolValue
            default:
                fatalError()
            }
        }
        
        if self.inverse {
            valueToSet = !valueToSet
        }
        
        do {
            try self.settingsProperty << SettingsPropertyValue.init(valueToSet)
        } catch _ { }
    }
}
