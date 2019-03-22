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
        return SettingsGroupCellDescriptor.init(items: [debugSection, topSection], title: "系统设置")
    }
    
    func versionElement() -> SettingsStaticTextCellDescriptor {
        let element = SettingsStaticTextCellDescriptor.init(text: "版本")
        element.previewGenerator = { (_) -> SettingsCellPreview in
            guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") else { fatalError() }
            return SettingsCellPreview.text("v\(version)")
        }
        return element
    }
    
    func introduceElement() -> SettingsExternalScreenCellDescriptor {
        let element = SettingsExternalScreenCellDescriptor(title: "SkyTool") { () -> (UIViewController?) in
//            if let path = Bundle.main.path(forResource: "index", ofType: "html", inDirectory: "html") {
//                let url = URL.init(fileURLWithPath: path)
//                return WebViewController(url)
//            }
            if let url = Settings.shared.introduceUrl {
                let viewController = WebViewController(url)
                viewController.title = "湖北鄂车介绍"
                return viewController
            }
            return nil
        }
        return element
    }
    
    func togglePushEnableElement() -> SettingsPropertyToggleCellDescriptor {
        let property = self.settingsPropertyFactory.property(.isPushEnabled)
        let element = SettingsPropertyToggleCellDescriptor.init(settingsProperty: property)
        return element
    }
    
    func feedBackElement() -> SettingsExternalScreenCellDescriptor {
        let element = SettingsExternalScreenCellDescriptor(title: "功能反馈") { () -> (UIViewController?) in
            return nil
        }
        return element
    }
    
    func passwordChangeElement() -> SettingsExternalScreenCellDescriptor {
        let element = SettingsExternalScreenCellDescriptor(title: "密码修改") { () -> (UIViewController?) in
            let viewController = ViewController()
            viewController.title = "修改密码"
            return viewController
        }
        element.previewGenerator = { (_) -> SettingsCellPreview in
            return SettingsCellPreview.text("修改密码")
        }
        return element
    }
    
    func logoutElement() -> SettingsCellDescriptorType {
        let logoutAction: () -> () = {
            guard let selectedAccount = SessionManager.shared.accountManager.selectedAccount else {
                Log.fatalError("无账号可以登出")
            }
            SessionManager.shared.delete(account: selectedAccount)
        }
        return SettingsExternalScreenCellDescriptor(title: "注销登录", isDestructive: true, presentationStyle: .modal, presentationAction: { () -> (UIViewController?) in
            let alert = UIAlertController.init(title: "登出", message: "确认登出吗？", preferredStyle: .alert)
            let actionCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(actionCancel)
            let actionLogout = UIAlertAction(title: "确定", style: .destructive, handler: { _ in logoutAction() })
            alert.addAction(actionLogout)
            return alert
        })
        
    }
}
