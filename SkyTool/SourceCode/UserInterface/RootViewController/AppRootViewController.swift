//
//  AppRootViewController.swift
//  HuBeiECarSalerClient
//
//  Created by tree on 2018/12/21.
//  Copyright © 2018 tree. All rights reserved.
//

import UIKit

class AppRootViewController: UIViewController {
    public let mainWindow: UIWindow
    //    public let overlayWindow: NotificationWindow
    
    public fileprivate(set) var visibilityViewController: UIViewController?
    fileprivate let appStateController: AppStateController
    
    fileprivate let transitionQueue: DispatchQueue = DispatchQueue.init(label: "transitionQueue")
    
    weak var presentedPopover: UIPopoverPresentationController?
    weak var popoverPointToView: UIView?
    
    public fileprivate(set) var sessionManager: SessionManager
    
    func updateOverlayWindowFrame() {
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        mainWindow.frame.size = size
        
        coordinator.animate(alongsideTransition: nil) { (_) in
            self.updateOverlayWindowFrame()
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        appStateController = AppStateController()
        
        let frame = UIScreen.main.bounds
        mainWindow = UIWindow.init(frame: frame)
        mainWindow.accessibilityIdentifier = "ClientMainWindow"
        //        overlayWindow = NotificationWindow(frame: frame)
        
        let bundle = Bundle.main
        
        let appVersion = bundle.infoDictionary?[kCFBundleVersionKey as String] as? String
        self.sessionManager = SessionManager.init(appVersion: appVersion!, delegate: appStateController, isTest: true)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        appStateController.delegate = self
        
        mainWindow.rootViewController = self
        mainWindow.makeKeyAndVisible()
        //        overlayWindow.makeKeyAndVisible()
        mainWindow.makeKey()
        
        transition(to: .headless)
        //        enqueueTransition(to: appStateController.appState)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    
    public func launch(with launchOptions: LaunchOptions) {
        self.sessionManager.start(launchOptions: launchOptions)
    }
}

extension AppRootViewController {
    func enqueueTransition(to appState: AppState, completion: (() -> Void)?=nil) {
        transitionQueue.async {
            let transitionGroup = DispatchGroup()
            transitionGroup.enter()
            DispatchQueue.main.async {
                self.applicationWillTransition(to: appState)
                transitionGroup.leave()
            }
            transitionGroup.wait()
        }
        transitionQueue.async {
            let transitionGroup = DispatchGroup()
            transitionGroup.enter()
            DispatchQueue.main.async {
                self.transition(to: appState, completionHandler: {
                    transitionGroup.leave()
                    self.applicationDidTransition(to: appState)
                    completion?()
                })
            }
            transitionGroup.wait()
        }
    }
    
    func transition(to appState: AppState, completionHandler: (() -> Void)?=nil) {
        var viewController: UIViewController?
        
        switch appState {
        case .headless:
            viewController = LaunchImageViewController()
            
        case .unauthenticated:
            let coordinator = AuthenticationCoordinator(account: nil)
            let loginViewController = LoginViewController(coordinator: coordinator)
            viewController = AuthenNavigationViewController(rootViewController: loginViewController)
            
        case .authenticated(_):
            viewController = MainTabBarViewController()
        }
        
        if let viewController = viewController {
            transition(to: viewController, animated: true) {
                completionHandler?()
            }
        } else {
            completionHandler?()
        }
    }
    
    private func dismissModalsFromAllChildren(of viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        for child in viewController.children {
            if child.presentedViewController != nil {
                child.dismiss(animated: false, completion: nil)
            }
            dismissModalsFromAllChildren(of: child)
        }
    }
    
    func transition(to viewController: UIViewController, animated: Bool = true, completionHandler: (()->Void)?=nil) {
        dismissModalsFromAllChildren(of: visibilityViewController)
        visibilityViewController?.willMove(toParent: nil)
        if let previousViewController = visibilityViewController, animated {
            addChild(viewController)
            transition(from: previousViewController,
                       to: viewController,
                       duration: 0.5,
                       options: UIView.AnimationOptions.transitionCrossDissolve,
                       animations: nil) { (_) in
                        viewController.didMove(toParent: self)
                        previousViewController.removeFromParent()
                        self.visibilityViewController = viewController
                        UIApplication.shared.updateStatusBarForCurrentControllerAnimated(true)
                        completionHandler?()
            }
        } else {
            UIView.performWithoutAnimation {
                visibilityViewController?.removeFromParent()
                addChild(viewController)
                viewController.view.frame = view.bounds
                viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                view.addSubview(viewController.view)
                visibilityViewController = viewController
                UIApplication.shared.updateStatusBarForCurrentControllerAnimated(false)
            }
            completionHandler?()
        }
    }
    
    func applicationWillTransition(to appState: AppState) {
        //        overlayWindow.rootViewController = NotificationWindowRootViewController()
    }
    
    func applicationDidTransition(to appState: AppState) {
//        if appState == .main {
//            // 如果有通知，放到这里处理
//        }
    }
    
    func reload() {
        enqueueTransition(to: .headless)
        enqueueTransition(to: appStateController.appState)
    }
}

extension AppRootViewController {
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        guard let topViewController = UIApplication.topViewController(from: self.visibilityViewController),
            topViewController is AppRootViewController == false else {
                return self.supportedOrientations
        }
        let supported = topViewController.supportedInterfaceOrientations
        return supported
    }
    
    override var prefersStatusBarHidden: Bool {
        guard let topViewController = UIApplication.topViewController(from: self.visibilityViewController),
            topViewController is AppRootViewController == false else {
                return false
        }
        return topViewController.prefersStatusBarHidden
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let topViewController = UIApplication.topViewController(from: self.visibilityViewController),
            topViewController is AppRootViewController == false else {
                return UIStatusBarStyle.default
        }
        return topViewController.preferredStatusBarStyle
    }
    
}

extension AppRootViewController: AppStateControllerDelegate {
    func appStateController(transitionedTo appState: AppState, transitionCompleted: @escaping () -> Void) {
        enqueueTransition(to: appState, completion: transitionCompleted)
    }
}

/// MARK: Application Icon Badge Number

extension AppRootViewController {
    fileprivate func applicationDidEnterBackground() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
