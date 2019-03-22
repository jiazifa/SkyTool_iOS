//
//  SettingsPropertyTextCellDescriptor.swift
//  SkyTool
//
//  Created by tree on 2019/3/22.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

class SettingsPropertyTextCellDescriptor: SettingsPropertyCellDescriptorType {
    var settingsProperty: SettingsProperty
    
    static var cellType: SettingsTableCell.Type = SettingsTextCell.self
    
    var visible: Bool = true
    
    var title: String {
        get {
            return SettingsPropertyLabelText(self.settingsProperty.propertyName)
        }
    }
    
    var identifier: String?
    
    weak var group: SettingsGroupCellDescriptorType?
    
    init(settingsProperty: SettingsProperty, identifier: String? = .none) {
        self.settingsProperty = settingsProperty
        self.identifier = identifier
    }
    
    func select(_ value: SettingsPropertyValue) {
        guard let stringValue = value.value() as? String else {
            return
        }
        do {
            try self.settingsProperty << SettingsPropertyValue.string(value: stringValue)
        } catch let error as NSError {
            Log.assertionFailure("\(error.localizedDescription)")
        }
    }
    
    func featureCell(_ cell: SettingsCellType) {
        cell.titleText = self.title
        if let textCell = cell as? SettingsTextCell,
            let stringValue = self.settingsProperty.rawValue() as? String {
            textCell.textInput.text = stringValue
        }
    }
    
}
