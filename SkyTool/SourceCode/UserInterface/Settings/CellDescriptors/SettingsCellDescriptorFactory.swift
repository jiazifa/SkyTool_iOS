//
//  SettingsCellDescriptorFactory.swift
//  HuBeiECarSalerClient
//
//  Created by tree on 2018/12/28.
//  Copyright © 2018 tree. All rights reserved.
//

import UIKit

class SettingsCellDescriptorFactory {
    
    let settingsPropertyFactory: SettingsPropertyFactory
    
    init(settingsPropertyFactory: SettingsPropertyFactory) {
        self.settingsPropertyFactory = settingsPropertyFactory
    }
    
    func rootGroup() -> SettingsControllerGeneratorType & SettingsInternalGroupCellDescriptorType {
        var rootElements: [SettingsCellDescriptorType] = []
        rootElements.append(introduceElement())
        rootElements.append(versionElement())
        rootElements.append(logoutElement())
        
        let debugSection = debugOptionSection()
        let topSection = SettingsSectionDescriptor(cellDescriptors: rootElements)
        return SettingsGroupCellDescriptor.init(items: [debugSection, topSection],
                                                title: "settings.system.setting.title".localized)
    }
    
    func versionElement() -> SettingsStaticTextCellDescriptor {
        let element = SettingsStaticTextCellDescriptor.init(text: "settings.system.version.title".localized)
        element.previewGenerator = { (_) -> SettingsCellPreview in
            guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") else { fatalError() }
            return SettingsCellPreview.text("v\(version)")
        }
        return element
    }
    
    func introduceElement() -> SettingsButtonCellDescriptor {
        let element = SettingsButtonCellDescriptor(title: "app.title".localized) { (_) in
            let url = UIApplication.introductionURL
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        return element
    }
    
    func togglePushEnableElement() -> SettingsPropertyToggleCellDescriptor {
        let property = self.settingsPropertyFactory.property(.isPushEnabled)
        let element = SettingsPropertyToggleCellDescriptor.init(settingsProperty: property)
        return element
    }
    
    func feedBackElement() -> SettingsExternalScreenCellDescriptor {
        let element = SettingsExternalScreenCellDescriptor(title: "settings.system.feedback.title".localized) { () -> (UIViewController?) in
            return nil
        }
        return element
    }
    
    func passwordChangeElement() -> SettingsExternalScreenCellDescriptor {
        let element = SettingsExternalScreenCellDescriptor(title: "settings.system.password.change.title".localized) { () -> (UIViewController?) in
            let viewController = ViewController()
            viewController.title = "settings.system.password.change.title".localized
            return viewController
        }
        element.previewGenerator = { (_) -> SettingsCellPreview in
            return SettingsCellPreview.text("settings.system.password.change.title".localized)
        }
        return element
    }
    
    func logoutElement() -> SettingsCellDescriptorType {
        let logoutAction: () -> () = {
            guard let selectedAccount = SessionManager.shared.accountManager.selectedAccount else {
                Log.fatalError("settings.alert.no.account.logout.title".localized)
            }
            SessionManager.shared.delete(account: selectedAccount)
        }
        return SettingsExternalScreenCellDescriptor(title: "settings.system.logout.title".localized, isDestructive: true, presentationStyle: .modal, presentationAction: { () -> (UIViewController?) in
            let alert = UIAlertController.init(title: "alert.logout.title".localized, message: "alert.logout.message".localized, preferredStyle: .alert)
            let actionCancel = UIAlertAction(title: "alert.cancel.action".localized, style: .cancel, handler: nil)
            alert.addAction(actionCancel)
            let actionLogout = UIAlertAction(title: "alert.comfirm.action".localized, style: .destructive, handler: { _ in logoutAction() })
            alert.addAction(actionLogout)
            return alert
        })
        
    }
}
