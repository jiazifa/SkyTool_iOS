//
//  UIViewController+Indicator.swift
//  SkyTool
//
//  Created by tree on 2019/4/20.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import PureLayout
import UIKit

extension UIViewController {
    private func getIndicator() -> UIActivityIndicatorView {
        var indicator: UIActivityIndicatorView? = self.view.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView
        if (indicator == nil) {
            indicator = UIActivityIndicatorView.init(style: .whiteLarge)
            indicator?.color = UIColor.white
            indicator?.backgroundColor = UIColor.gray
            indicator?.hidesWhenStopped = true
        }
        return indicator!
    }
    
    func startIndicator() {
        let indicator = self.getIndicator()
        self.view.addSubview(indicator)
        indicator.autoSetDimensions(to: CGSize(width: 100, height: 100))
        indicator.layer.cornerRadius = 10
        indicator.autoCenterInSuperview()
        indicator.startAnimating()
    }
    
    func stopIndicator() {
        self.getIndicator().stopAnimating()
    }
}
