//
//  SettingsStaticTextCellDescriptor.swift
//  HuBeiECarSalerClient
//
//  Created by tree on 2018/12/28.
//  Copyright © 2018 tree. All rights reserved.
//

import UIKit

class SettingsStaticTextCellDescriptor: SettingsCellDescriptorType {    
    static let cellType: SettingsTableCell.Type = SettingsStaticTextTableCell.self
    
    var text: String
    
    init(text: String) {
        self.text = text
        self.identifier = .none
        self.previewGenerator = nil
    }
    
    var visible: Bool { return true }
    
    var title: String { return text }
    
    var identifier: String?
    
    weak var group: SettingsGroupCellDescriptorType?
    var previewGenerator: PreviewGeneratorType?
    
    func select(_: SettingsPropertyValue) {
        
    }
    
    func featureCell(_ cell: SettingsCellType) {
        cell.titleText = self.text
        cell.titleColor = .textBlack
        if let previewGenerator = self.previewGenerator {
            let preview = previewGenerator(self)
            cell.preview = preview
        }
    }
}
