//
//  SelfProfileController.swift
//  SkyTool
//
//  Created by tree on 2019/4/9.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import UIKit

class SelfProfileController {
    var account: Account
    
    public let onHeadImage = Delegate<UIImage, Void>()
    
    init(account: Account) {
        self.account = account
    }
    
    func modifyImage() {
        
    }
}
