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
    
    func debugOptionGroup() -> SettingsExternalScreenCellDescriptor {
        
        let element = SettingsExternalScreenCellDescriptor(title: "开发者选项") { () -> (UIViewController?) in
            let rootElements: [SettingsCellDescriptorType] = []
            let topSection = SettingsSectionDescriptor(cellDescriptors: rootElements)
            let group = SettingsGroupCellDescriptor.init(items: [topSection], title: "开发者选项")
            let viewController = SettingsTableViewController.init(group: group)
            return viewController
        }
        return element
    }
}
