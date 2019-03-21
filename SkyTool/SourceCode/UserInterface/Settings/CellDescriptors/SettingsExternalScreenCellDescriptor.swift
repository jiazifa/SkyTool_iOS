//
//  SettingsExternalScreenCellDescriptor.swift
//  HuBeiECarSalerClient
//
//  Created by tree on 2018/12/28.
//  Copyright © 2018 tree. All rights reserved.
//

import UIKit

enum PresentationStyle: Int {
    case modal
    case navigation
}

enum AccessoryViewMode: Int {
    case `default`
    case alwaysShow
    case alwaysHide
}

class SettingsExternalScreenCellDescriptor: SettingsExternalScreenCellDescriptorType,
                                            SettingsControllerGeneratorType {
    
    static let cellType: SettingsTableCell.Type = SettingsGroupCell.self
    var visible: Bool = true
    let title: String
    let destructive: Bool
    let presentationStyle: PresentationStyle
    let identifier: String?
    
    private let accessoryViewMode: AccessoryViewMode
    
    weak var group: SettingsGroupCellDescriptorType?
    weak var viewController: UIViewController?
    
    var previewGenerator: PreviewGeneratorType?
    
    let presentationAction: () -> (UIViewController?)
    
    convenience init(title: String, presentationAction: @escaping () -> (UIViewController?)) {
        self.init(
            title: title,
            isDestructive: false,
            presentationStyle: .navigation,
            identifier: nil,
            presentationAction: presentationAction,
            previewGenerator: nil,
            accessoryViewMode: .default
        )
    }
    
    convenience init(title: String,
                     isDestructive: Bool,
                     presentationStyle: PresentationStyle,
                     presentationAction: @escaping () -> (UIViewController?),
                     previewGenerator: PreviewGeneratorType? = .none,
                     accessoryViewMode: AccessoryViewMode = .default) {
        self.init(
            title: title,
            isDestructive: isDestructive,
            presentationStyle: presentationStyle,
            identifier: nil,
            presentationAction: presentationAction,
            previewGenerator: previewGenerator,
            accessoryViewMode: accessoryViewMode
        )
    }
    
    init(title: String, isDestructive: Bool,
         presentationStyle: PresentationStyle,
         identifier: String?,
         presentationAction: @escaping () -> (UIViewController?),
         previewGenerator: PreviewGeneratorType? = .none,
         accessoryViewMode: AccessoryViewMode = .default) {
        self.title = title
        self.destructive = isDestructive
        self.presentationStyle = presentationStyle
        self.presentationAction = presentationAction
        self.identifier = identifier
        self.previewGenerator = previewGenerator
        self.accessoryViewMode = accessoryViewMode
    }
    
    func select(_: SettingsPropertyValue) {
        guard let controllerToShow = self.generateViewController() else {
            return
        }
        
        switch self.presentationStyle {
        case .modal:
            if controllerToShow.modalPresentationStyle == .popover,
                let sourceView = self.viewController?.view,
                let popoverPresentation = controllerToShow.popoverPresentationController {
                popoverPresentation.sourceView = sourceView
                popoverPresentation.sourceRect = sourceView.bounds
            }
            
            controllerToShow.modalPresentationCapturesStatusBarAppearance = true
            self.viewController?.present(controllerToShow, animated: true, completion: .none)
            
        case .navigation:
            if let navigationController = self.viewController?.navigationController {
                navigationController.pushViewController(controllerToShow, animated: true)
            }
        }
    }
    
    func featureCell(_ cell: SettingsCellType) {
        cell.titleText = self.title
        cell.titleColor = UIColor.textBlack
        
        if let previewGenerator = self.previewGenerator {
            let preview = previewGenerator(self)
            cell.preview = preview
        }
        if let groupCell = cell as? SettingsGroupCell {
            switch accessoryViewMode {
            case .default:
                if self.presentationStyle == .modal {
                    groupCell.accessoryType = .none
                } else {
                    groupCell.accessoryType = .disclosureIndicator
                }
            case .alwaysHide:
                groupCell.accessoryType = .none
            case .alwaysShow:
                groupCell.accessoryType = .disclosureIndicator
            }
            
        }
    }
    
    func generateViewController() -> UIViewController? {
        return self.presentationAction()
    }
}
