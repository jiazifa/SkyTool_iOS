//
//  ChangePasswordViewController.swift
//  HuBeiECarSalerClient
//
//  Created by tree on 2019/1/5.
//  Copyright © 2019 tree. All rights reserved.
//

import UIKit
import PureLayout
import YYKit.YYTextAttribute
import YYKit.YYLabel

class ChangePasswordViewController: UIViewController {
    
    private lazy var originPsdTextField: UITextField = {
        let textfield = UITextField.init()
        textfield.leftViewMode = .always
        textfield.font = UIFont.normalLightFont
        textfield.textColor = UIColor.textBlack
        textfield.isSecureTextEntry = true
        let attr = NSMutableAttributedString.init(string: "请输入原始密码")
        attr.font = UIFont.normalLightFont
        attr.color = UIColor.textPlaceholder
        textfield.attributedPlaceholder = attr
        let label = UILabel.init()
        label.text = "原始密码"
        label.font = UIFont.normalLightFont
        label.textColor = UIColor.textBlack
        label.size = CGSize.init(width: 70.0, height: 30.0)
        textfield.leftView = label
        return textfield
    }()
    
    private lazy var originPsdLine: UIView = {
        let line = UIView.init()
        line.backgroundColor = UIColor.separator
        return line
    }()
    
    private lazy var newPsdTextField: UITextField = {
        let textfield = UITextField.init()
        textfield.leftViewMode = .always
        textfield.font = UIFont.normalLightFont
        textfield.textColor = UIColor.textBlack
        textfield.isSecureTextEntry = true
        let attr = NSMutableAttributedString.init(string: "新密码")
        attr.font = UIFont.normalLightFont
        attr.color = UIColor.textPlaceholder
        textfield.attributedPlaceholder = attr
        let label = UILabel.init()
        label.text = "新密码"
        label.font = UIFont.normalLightFont
        label.textColor = UIColor.textBlack
        label.size = CGSize.init(width: 70.0, height: 30.0)
        textfield.leftView = label
        return textfield
    }()
    
    private lazy var newPsdLine: UIView = {
        let line = UIView.init()
        line.backgroundColor = UIColor.separator
        return line
    }()
    
    private lazy var verfPsdTextField: UITextField = {
        let textfield = UITextField.init()
        textfield.leftViewMode = .always
        textfield.font = UIFont.normalLightFont
        textfield.textColor = UIColor.textBlack
        textfield.isSecureTextEntry = true
        let attr = NSMutableAttributedString.init(string: "确认密码")
        attr.font = UIFont.normalLightFont
        attr.color = UIColor.textPlaceholder
        textfield.attributedPlaceholder = attr
        let label = UILabel.init()
        label.text = "确认密码"
        label.font = UIFont.normalLightFont
        label.textColor = UIColor.textBlack
        label.size = CGSize.init(width: 70.0, height: 30.0)
        textfield.leftView = label
        return textfield
    }()
    
    private lazy var verfPsdLine: UIView = {
        let line = UIView.init()
        line.backgroundColor = UIColor.separator
        return line
    }()
    
    private lazy var commitButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setTitle("确定", for: .normal)
        button.titleLabel?.font = UIFont.normalLightFont
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.blueTheme
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        return button
    }()
    
    private lazy var infoLabel: YYLabel = {
        let label = YYLabel.init()
        let attr = NSMutableAttributedString.init()
        attr.append({
            let append = NSMutableAttributedString.init(string: " 忘记密码?")
            append.font = UIFont.smallLightFont
            append.setTextHighlight(append.rangeOfAll(),
                                    color: UIColor.textBlack,
                                    backgroundColor: nil,
                                    tapAction: { (_, _, _, _) in
                                        DLog("忘记密码")
            })
            return append
            }())
        
        attr.alignment = .right
        label.attributedText = attr
        return label
    }()
    
    let coordinator: AuthenticationCoordinator
    
    init(coordinator: AuthenticationCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubViews()
        self.createConstrains()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupSubViews() {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.originPsdTextField)
        self.view.addSubview(self.originPsdLine)
        self.view.addSubview(self.newPsdTextField)
        self.view.addSubview(self.newPsdLine)
        self.view.addSubview(self.verfPsdTextField)
        self.view.addSubview(self.verfPsdLine)
        self.view.addSubview(self.commitButton)
        self.view.addSubview(self.infoLabel)
    }
    
    private func createConstrains() {
        
        self.originPsdTextField.autoAlignAxis(toSuperviewAxis: .vertical)
        self.originPsdTextField.autoPinEdge(toSuperviewSafeArea: .top, withInset: 10)
        self.originPsdTextField.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        self.originPsdTextField.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        self.originPsdTextField.autoSetDimension(.height, toSize: 50)
        
        self.originPsdLine.autoPinEdge(.left, to: .left, of: self.originPsdTextField)
        self.originPsdLine.autoPinEdge(.right, to: .right, of: self.originPsdTextField)
        self.originPsdLine.autoPinEdge(.bottom, to: .bottom, of: self.originPsdTextField)
        self.originPsdLine.autoSetDimension(.height, toSize: 0.5)
        
        self.newPsdTextField.autoAlignAxis(toSuperviewAxis: .vertical)
        self.newPsdTextField.autoPinEdge(.top, to: .bottom, of: self.originPsdTextField)
        self.newPsdTextField.autoPinEdge(.left, to: .left, of: self.originPsdTextField)
        self.newPsdTextField.autoPinEdge(.right, to: .right, of: self.originPsdTextField)
        self.newPsdTextField.autoMatch(.height,
                                       to: .height,
                                       of: self.originPsdTextField,
                                       withMultiplier: 1,
                                       relation: .equal)
        
        self.newPsdLine.autoPinEdge(.left, to: .left, of: self.newPsdTextField)
        self.newPsdLine.autoPinEdge(.right, to: .right, of: self.newPsdTextField)
        self.newPsdLine.autoPinEdge(.bottom, to: .bottom, of: self.newPsdTextField)
        self.newPsdLine.autoMatch(.height,
                                  to: .height,
                                  of: self.originPsdLine,
                                  withMultiplier: 1,
                                  relation: .equal)
        
        self.verfPsdTextField.autoAlignAxis(toSuperviewAxis: .vertical)
        self.verfPsdTextField.autoPinEdge(.top, to: .bottom, of: self.newPsdTextField)
        self.verfPsdTextField.autoPinEdge(.left, to: .left, of: self.newPsdTextField)
        self.verfPsdTextField.autoPinEdge(.right, to: .right, of: self.newPsdTextField)
        self.verfPsdTextField.autoMatch(.height,
                                        to: .height,
                                        of: self.originPsdTextField,
                                        withMultiplier: 1,
                                        relation: .equal)
        
        self.verfPsdLine.autoPinEdge(.left, to: .left, of: self.verfPsdTextField)
        self.verfPsdLine.autoPinEdge(.right, to: .right, of: self.verfPsdTextField)
        self.verfPsdLine.autoPinEdge(.bottom, to: .bottom, of: self.verfPsdTextField)
        self.verfPsdLine.autoMatch(.height,
                                   to: .height,
                                   of: self.originPsdLine,
                                   withMultiplier: 1,
                                   relation: .equal)
        
        self.commitButton.autoAlignAxis(toSuperviewAxis: .vertical)
        self.commitButton.autoPinEdge(.top, to: .bottom, of: self.verfPsdTextField, withOffset: 40.0)
        self.commitButton.autoPinEdge(toSuperviewEdge: .left, withInset: 40)
        self.commitButton.autoPinEdge(toSuperviewEdge: .right, withInset: 40)
        self.commitButton.autoMatch(.height,
                                    to: .height,
                                    of: self.originPsdTextField,
                                    withMultiplier: 1,
                                    relation: .equal)
        
        self.infoLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        self.infoLabel.autoPinEdge(.top, to: .bottom, of: self.commitButton, withOffset: 10.0)
        self.infoLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 30)
        self.infoLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 30)
    }
}
