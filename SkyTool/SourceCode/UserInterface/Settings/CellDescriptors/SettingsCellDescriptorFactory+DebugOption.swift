//
//  SettingsCellDescriptorFactory+DebugOption.swift
//  HuBeiECarSalerClient
//
//  Created by tree on 2019/1/5.
//  Copyright © 2019 tree. All rights reserved.
//

import Foundation
import UIKit

extension SettingsCellDescriptorFactory {
    
    func debugOptionSection() -> SettingsSectionDescriptorType {
        
        var elements = [SettingsCellDescriptorType]()
        elements.append(self.hostElement())
        let section = SettingsSectionDescriptor(cellDescriptors: elements,
                                                header: "开发者选项",
                                                footer: nil,
                                                visibilityAction: nil)
        return section
    }
    
    func hostElement() -> SettingsPropertyCellDescriptorType {
        let property = self.settingsPropertyFactory.property(.touchuHostAddress)
        let element = SettingsPropertyTextCellDescriptor.init(settingsProperty: property)
        return element
    }
}
