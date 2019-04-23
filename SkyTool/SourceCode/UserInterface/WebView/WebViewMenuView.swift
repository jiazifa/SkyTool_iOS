//
//  WebViewMenuView.swift
//  SkyTool
//
//  Created by tree on 2019/4/23.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

class WebViewMenuView: UIView {
    
    let stackView: UIStackView = UIStackView.init()
    
    let container: UIView = UIView()
    
    var backButton: UIButton = {
        let button = UIButton(forAutoLayout: ())
        button.setImage(UIImage.init(named: "back"), for: .normal)
        return button
    }()
    
    var previewButton: UIButton = {
        let button = UIButton(forAutoLayout: ())
        button.setImage(UIImage.init(named: "right_arrow"), for: .normal)
        return button
    }()
    
    var refreshButton: UIButton = {
        let button = UIButton(forAutoLayout: ())
        button.setImage(UIImage.init(named: "refresh"), for: .normal)
        return button
    }()
    
    convenience init() {
        self.init(frame: .zero)
        self.setupSubViews()
        self.createConstraints()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        self.backgroundColor = UIColor.white
        self.stackView.addArrangedSubview(self.backButton)
        self.stackView.addArrangedSubview(self.refreshButton)
        self.stackView.addArrangedSubview(self.previewButton)
        self.container.addSubview(stackView)
        self.addSubview(self.container)
    }
    
    func createConstraints() {
        self.container.autoPinEdge(toSuperviewEdge: .top)
        self.container.autoPinEdge(toSuperviewEdge: .left)
        self.container.autoPinEdge(toSuperviewEdge: .right)
        self.container.autoSetDimension(.height, toSize: 44, relation: .greaterThanOrEqual)
        
        self.stackView.axis = .horizontal
        self.stackView.alignment = .fill
        self.stackView.distribution = .fillEqually
        self.stackView.spacing = 10
        self.stackView.autoPinEdgesToSuperviewEdges()
    }
}
