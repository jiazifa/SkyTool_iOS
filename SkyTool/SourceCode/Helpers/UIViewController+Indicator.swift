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
        var indicator = self.view.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView
        if (indicator == nil) {
            indicator = UIActivityIndicatorView.init(style: .whiteLarge)
            indicator?.color = UIColor.white
            indicator?.backgroundColor = UIColor.gray
            indicator?.hidesWhenStopped = true
        }
        return indicator!
    }
    
    func startIndicator() {
        DispatchQueue.main.async {
            let indicator = self.getIndicator()
            self.view.addSubview(indicator)
            indicator.autoSetDimensions(to: CGSize(width: 100, height: 100))
            indicator.layer.cornerRadius = 10
            indicator.autoCenterInSuperview()
            indicator.startAnimating()
        }
    }
    
    func stopIndicator() {
        DispatchQueue.main.async {
            self.getIndicator().stopAnimating()
        }
    }
}

final class _NotifyLabel: UILabel {}
extension UIViewController {
    private func getToasLabel() -> UILabel {
        let label = _NotifyLabel.init()
        label.font = .normalFont
        label.numberOfLines = 3
        label.textAlignment = .center
        label.backgroundColor = UIColor.black
        label.textColor = .white
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        return label
    }
    
    func toast(content: String) {
        guard let view = UIApplication.shared.keyWindow else { return }
        let label = getToasLabel()
        view.addSubview(label)
        label.text = content
        label.autoAlignAxis(toSuperviewAxis: .vertical)
        label.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 100)
        let size = (content as NSString).size(for: .normalFont, size: CGSize.init(width: view.width - 30, height: 100), mode: .byCharWrapping)
        label.autoSetDimensions(to: CGSize.init(width: size.width + 30, height: size.height + 20))
        let second = min(ceil(1.7 + Double(content.count) * 0.1), 4)
        delay(second, closure: {
            label.removeFromSuperview()
        })
    }
}


extension UIViewController {
    func notify(message: NotifyMessage) {
        switch message.type {
        case .toast:
            toast(content: message.content)
        case .dropDown: fatalError()
        @unknown default: break
        }
    }
}
