//
//  UIApplication+statusBar.swift
//  GrillNowiOS
//
//  Created by tree on 2018/11/23.
//  Copyright © 2018 tree. All rights reserved.
//

import UIKit

public extension UIApplication {
    static let statusBarStyleChangeNotification: Notification.Name = {
        return Notification.Name("statusBarStyleChangeNotification")
    }()

    @objc func updateStatusBarForCurrentControllerAnimated(_ animated: Bool) {
        updateStatusBarForCurrentControllerAnimated(animated, onlyFullScreen: true)
    }

    @objc func updateStatusBarForCurrentControllerAnimated(_ animated: Bool, onlyFullScreen: Bool) {
        let statusBarHidden: Bool
        let statusBarStyle: UIStatusBarStyle

        if let topContoller = self.topmostController(onlyFullScreen: onlyFullScreen) {
            statusBarHidden = topContoller.prefersStatusBarHidden
            statusBarStyle = topContoller.preferredStatusBarStyle
        } else {
            statusBarHidden = true
            statusBarStyle = .lightContent
        }

        var changed = false

        if self.isStatusBarHidden != statusBarHidden {
            if #available(iOS 9.0, *) {} else {
                self.setStatusBarHidden(statusBarHidden, with: animated ? .fade : .none)
                changed = true
            }
        }

        if self.statusBarStyle != statusBarStyle {
            if #available(iOS 9.0, *) {} else {
                self.setStatusBarStyle(statusBarStyle, animated: animated)
                changed = true
            }
        }

        if changed {
            let notificationName = type(of: self).statusBarStyleChangeNotification
            NotificationCenter.default.post(name: notificationName, object: self)
        }
    }

    @objc func topmostViewController() -> UIViewController? {
        return topmostController()
    }

    /// return the visible window on the top most which fulfills these conditions:
    /// 1. the windows has rootViewController
    /// 3. the window's rootViewController is AppRootViewController
    var topMostVisibleWindow: UIWindow? {
        let orderedWindows = self.windows.sorted { win1, win2 in
            win1.windowLevel < win2.windowLevel
        }

        let visibleWindow = orderedWindows.filter {
            guard let controller = $0.rootViewController else {
                return false
            }
            if controller is AppRootViewController {
                return true
            } else {
                return false
            }
        }

        return visibleWindow.last
    }

    func topmostController(onlyFullScreen: Bool = true) -> UIViewController? {

        guard let window = topMostVisibleWindow,
            var topController = window.rootViewController else {
                return .none
        }

        while let presentedController = topController.presentedViewController,
            (!onlyFullScreen || presentedController.modalPresentationStyle == .fullScreen) {
            topController = presentedController
        }

        return topController
    }
}
