//
//  AppStateController.swift
//  HuBeiECarSalerClient
//
//  Created by tree on 2018/12/21.
//  Copyright © 2018 tree. All rights reserved.
//

import UIKit

protocol AppStateControllerDelegate: class {
    func appStateController(transitionedTo appState: AppState, transitionCompleted: @escaping () -> Void)
}

class AppStateController {
    private(set) var appState: AppState = .headless
    private(set) var lastState: AppState = .headless
    public weak var delegate: AppStateControllerDelegate?
    
    fileprivate var hasEnteredForeground = false
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        self.appState = calculateAppState()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func accountStateModified() {
        updateAppState()
    }
    
    @objc func applicationDidBecomeActive() {
        hasEnteredForeground = true
        updateAppState()
    }
    
    func calculateAppState() -> AppState {
        if !hasEnteredForeground {
            return .headless
        }
        return .main
    }
    
    func updateAppState(completion: (() -> Void)? = nil) {
        let newState = calculateAppState()
        if newState != appState {
            lastState = appState
            appState = newState
            delegate?.appStateController(transitionedTo: appState, transitionCompleted: {
                completion?()
            })
        } else {
            completion?()
        }
    }
}
