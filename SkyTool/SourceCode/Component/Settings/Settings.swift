//
//  Settings.swift
//  HuBeiECarSalerClient
//
//  Created by tree on 2018/12/21.
//  Copyright © 2018 tree. All rights reserved.
//

import UIKit

let UserDefaultPushDisabled: String = "UserDefaultPushDisabled"
let UserDefaultTouchHostAddress: String = "UserDefaultTouchHostAddress"
let UserDefaultIntroduceUrlString: String = "UserDefaultIntroduceUrlString"

class Settings {
    public static let shared = Settings()
    
    public var isPushDisable: Bool {
        get {
            return self.defaults.bool(forKey: UserDefaultPushDisabled)
        }
        set {
            self.defaults.set(newValue, forKey: UserDefaultPushDisabled)
            self.synchronize()
        }
    }
    
    public var touchHostAddress: String? {
        get {
            return self.defaults.string(forKey: UserDefaultTouchHostAddress)
        }
        set {
            self.defaults.set(newValue, forKey: UserDefaultTouchHostAddress)
            self.synchronize()
        }
    }
    
    public var introduceUrl: URL? {
        get {
            return self.defaults.url(forKey: UserDefaultIntroduceUrlString)
        }
        set {
            self.defaults.set(newValue, forKey: UserDefaultIntroduceUrlString)
            self.synchronize()
        }
    }
    
    // MARK: private variable
    private let defaults: UserDefaults = UserDefaults.standard
    
    private let allDefaultsKeys: [String] = [
        UserDefaultPushDisabled
    ]
    
    private init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidEnterBackground(_:)),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didEnterBackgroundNotification,
                                                  object: nil)
    }
}

extension Settings {
    
    func reset() {
        for key in self.allDefaultsKeys {
            self.defaults.removeObject(forKey: key)
        }
        self.synchronize()
    }
    
    @objc func applicationDidEnterBackground(_ application: UIApplication) {
        self.synchronize()
    }
    
    func synchronize() {
        self.defaults.synchronize()
    }
}
