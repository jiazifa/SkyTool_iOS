//
//  SettingsButtonCellDescriptor.swift
//  SkyTool
//
//  Created by tree on 2019/4/9.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import UIKit

class SettingsButtonCellDescriptor: SettingsCellDescriptorType {
    static var cellType: SettingsTableCell.Type = SettingsButtonCell.self
    
    var visible: Bool {
        if let visibilityAction = self.visibilityAction {
            return visibilityAction(self)
        }
        return true
    }
    
    var title: String
    
    var identifier: String?
    
    weak var group: SettingsGroupCellDescriptorType?
    
    let selectAction: (SettingsCellDescriptorType) -> ()
    let visibilityAction: ((SettingsCellDescriptorType) -> Bool)?
    
    init(title: String, selectAction: @escaping (SettingsCellDescriptorType) -> ()) {
        self.title = title
        self.selectAction = selectAction
        self.visibilityAction = .none
        self.identifier = .none
    }
    
    func select(_ value: SettingsPropertyValue) {
        self.selectAction(self)
    }
    
    func featureCell(_ cell: SettingsCellType) {
        cell.titleText = self.title
        cell.titleColor = UIColor.black
    }
}
