//
//  String+localized.swift
//  GrillNowiOS
//
//  Created by tree on 2018/11/30.
//  Copyright © 2018 tree. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
