//
//  ButtonWithLargerHitArea.swift
//  HuBeiECarSalerClient
//
//  Created by tree on 2018/12/21.
//  Copyright © 2018 tree. All rights reserved.
//

import UIKit

class ButtonWithLargerHitArea: UIButton {
    
    var hitAreaPadding: CGSize?
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if self.isHidden
            || self.alpha == 0.0
            || self.isUserInteractionEnabled == false {
            
            return false
        }
        var bounds = self.bounds
        bounds = bounds.insetBy(dx: -(self.hitAreaPadding?.width ?? 0.0),
                                dy: -(self.hitAreaPadding?.height ?? 0.0))
        return bounds.contains(point)
    }

}
