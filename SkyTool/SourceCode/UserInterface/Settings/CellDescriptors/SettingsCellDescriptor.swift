//
//  SettingsCellDescriptor.swift
//  HuBeiECarSalerClient
//
//  Created by tree on 2018/12/28.
//  Copyright © 2018 tree. All rights reserved.
//

import UIKit

/**
 * Top-level structure overview:
 * Settings group (screen) @c SettingsGroupCellDescriptorType contains
 * |--Settings section (table view section) @c SettingsSectionDescriptorType
 * |   |--Cell @c SettingsCellDescriptorType
 * |   |--Subgroup @c SettingsGroupCellDescriptorType
 * |   |  \..
 * |   \..
 * \...
 */

protocol SettingsCellDescriptorType: class {
    static var cellType: SettingsTableCell.Type {get}
    var visible: Bool {get}
    var title: String {get}
    var identifier: String? {get}
    var group: SettingsGroupCellDescriptorType? {get}
    
    func select(_ value: SettingsPropertyValue)
    func featureCell(_ cell: SettingsCellType)
}

func == (left: SettingsCellDescriptorType, right: SettingsCellDescriptorType) -> Bool {
    if let leftID = left.identifier,
        let rightID = right.identifier {
        return leftID == rightID
    } else {
        return left == right
    }
}

typealias PreviewGeneratorType = (SettingsCellDescriptorType) -> SettingsCellPreview

protocol SettingsGroupCellDescriptorType: SettingsCellDescriptorType {
    var viewController: UIViewController? {get set}
}

protocol SettingsSectionDescriptorType: class {
    var cellDescriptors: [SettingsCellDescriptorType] {get}
    var visibleCellDescriptors: [SettingsCellDescriptorType] {get}
    var header: String? {get}
    var footer: String? {get}
    var visible: Bool {get}
}

extension SettingsSectionDescriptorType {
    func allCellDescriptors() -> [SettingsCellDescriptorType] {
        return cellDescriptors
    }
}

enum InternalScreenStyle {
    case plain
    case grouped
}

protocol SettingsInternalGroupCellDescriptorType: SettingsGroupCellDescriptorType {
    var items: [SettingsSectionDescriptorType] {get}
    var visibleItems: [SettingsSectionDescriptorType] {get}
    var style: InternalScreenStyle {get}
}

extension SettingsInternalGroupCellDescriptorType {
    func allCellDescriptors() -> [SettingsCellDescriptorType] {
        return items.flatMap({ (section: SettingsSectionDescriptorType) -> [SettingsCellDescriptorType] in
            return section.allCellDescriptors()
        })
    }
}

protocol SettingsExternalScreenCellDescriptorType: SettingsGroupCellDescriptorType {
    var presentationAction: () -> (UIViewController?) {get}
}

protocol SettingsPropertyCellDescriptorType: SettingsCellDescriptorType {
    var settingsProperty: SettingsProperty {get}
}

protocol SettingsControllerGeneratorType {
    func generateViewController() -> UIViewController?
}

// MARK: - Classes

class SettingsSectionDescriptor: SettingsSectionDescriptorType {
    let cellDescriptors: [SettingsCellDescriptorType]
    var visibleCellDescriptors: [SettingsCellDescriptorType] {
        return self.cellDescriptors.filter {
            $0.visible
        }
    }
    var visible: Bool {
        if let visibilityAction = self.visibilityAction {
            return visibilityAction(self)
        } else {
            return true
        }
        
    }
    let visibilityAction: ((SettingsSectionDescriptorType) -> (Bool))?
    
    let header: String?
    let footer: String?
    
    init(cellDescriptors: [SettingsCellDescriptorType], header: String? = .none, footer: String? = .none, visibilityAction: ((SettingsSectionDescriptorType) -> (Bool))? = .none) {
        self.cellDescriptors = cellDescriptors
        self.header = header
        self.footer = footer
        self.visibilityAction = visibilityAction
    }
}

class SettingsGroupCellDescriptor: SettingsInternalGroupCellDescriptorType, SettingsControllerGeneratorType {
    
    static let cellType: SettingsTableCell.Type = SettingsGroupCell.self
    var visible: Bool = true
    let title: String
    let style: InternalScreenStyle
    let items: [SettingsSectionDescriptorType]
    let identifier: String?
    
    let previewGenerator: PreviewGeneratorType?
    
    weak var group: SettingsGroupCellDescriptorType?
    
    var visibleItems: [SettingsSectionDescriptorType] {
        return self.items.filter {
            $0.visible
        }
    }
    
    weak var viewController: UIViewController?
    
    init(items: [SettingsSectionDescriptorType], title: String, style: InternalScreenStyle = .grouped, identifier: String? = .none, previewGenerator: PreviewGeneratorType? = .none) {
        self.items = items
        self.title = title
        self.style = style
        self.identifier = identifier
        self.previewGenerator = previewGenerator
    }
    
    func featureCell(_ cell: SettingsCellType) {
        cell.titleText = self.title
        if let previewGenerator = self.previewGenerator {
            let preview = previewGenerator(self)
            cell.preview = preview
        }
    }
    
    func select(_: SettingsPropertyValue) {
        if let navigationController = self.viewController?.navigationController,
            let controllerToPush = self.generateViewController() {
            navigationController.pushViewController(controllerToPush, animated: true)
        }
    }
    
    func generateViewController() -> UIViewController? {
        return SettingsTableViewController.init(group: self)
    }
}

// Helper
func SettingsPropertyLabelText(_ name: SettingsPropertyName) -> String {
    switch name {
    case .isPushEnabled:
        return "消息推送设置"
    }
}
