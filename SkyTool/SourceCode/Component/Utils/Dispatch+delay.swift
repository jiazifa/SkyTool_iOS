//
//  Dispatch+delay.swift
//  GrillNowiOS
//
//  Created by tree on 2018/11/30.
//  Copyright © 2018 tree. All rights reserved.
//

import Foundation

/// delay `delay` seconds to call closure
///
/// - Parameters:
///   - delay: delay seconds
///   - closure: callback
func delay(_ delay: Double, closure: @escaping () -> Void) {
    
    let deadline = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(
        deadline: deadline,
        execute: closure)
}
