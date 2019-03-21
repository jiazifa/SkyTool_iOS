//
//  RegistViewController.swift
//  HuBeiECarSalerClient
//
//  Created by tree on 2019/1/5.
//  Copyright © 2019 tree. All rights reserved.
//

import UIKit
import PureLayout
import YYKit.YYTextAttribute
import YYKit.YYLabel

class RegistViewController: UIViewController {
    
    private lazy var phoneNumerTextField: UITextField = {
        let textfield = UITextField.init()
        textfield.backgroundColor = UIColor.white
        textfield.leftViewMode = .always
        textfield.font = UIFont.normalLightFont
        textfield.textColor = UIColor.textBlack
        let attr = NSMutableAttributedString.init(string: "请输入手机号码")
        attr.font = UIFont.normalLightFont
        attr.color = UIColor.textPlaceholder
        textfield.attributedPlaceholder = attr
        let label = UILabel.init()
        label.text = "手机号"
        label.font = UIFont.normalLightFont
        label.textColor = UIColor.textBlack
        label.size = CGSize.init(width: 70.0, height: 30.0)
        textfield.leftView = label
        return textfield
    }()
    
    private lazy var phoneNumerLine: UIView = {
        let line = UIView.init()
        line.backgroundColor = UIColor.separator
        return line
    }()
    
    private lazy var getCodeButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("获取验证码", for: .normal)
        button.setTitleColor(UIColor.blueTheme, for: .normal)
        button.titleLabel?.font = UIFont.normalLightFont
        button.size = CGSize.init(width: 100.0, height: 30.0)
        button.layer.cornerRadius = 15.0
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.blueTheme.cgColor
        button.layer.masksToBounds = false
        return button
    }()
    
    private lazy var verfCodeTextField: UITextField = {
        let textfield = UITextField.init()
        textfield.backgroundColor = UIColor.white
        textfield.font = UIFont.normalLightFont
        textfield.textColor = UIColor.textBlack
        let attr = NSMutableAttributedString.init(string: "请输入验证码")
        attr.font = UIFont.normalLightFont
        attr.color = UIColor.textPlaceholder
        textfield.attributedPlaceholder = attr
        
        let label = UILabel.init()
        label.text = "验证码"
        label.font = UIFont.normalLightFont
        label.textColor = UIColor.textBlack
        label.size = CGSize.init(width: 70.0, height: 30.0)
        textfield.leftViewMode = .always
        textfield.leftView = label
        textfield.rightViewMode = .always
        textfield.rightView?.isUserInteractionEnabled = true
        textfield.rightView = self.getCodeButton
        return textfield
    }()
    
    private lazy var verfCodeLine: UIView = {
        let line = UIView.init()
        line.backgroundColor = UIColor.separator
        return line
    }()
    
    private lazy var newPsdTextField: UITextField = {
        let textfield = UITextField.init()
        textfield.leftViewMode = .always
        textfield.backgroundColor = UIColor.white
        textfield.isSecureTextEntry = true
        textfield.font = UIFont.normalLightFont
        textfield.textColor = UIColor.textBlack
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
    
    private lazy var commitButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setTitle("确定", for: .normal)
        button.titleLabel?.font = UIFont.normalSemiboldFont
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.blueTheme
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        return button
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
        self.title = "手机注册"
        self.setupSubViews()
        self.createConstrains()
        self.createReacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupSubViews() {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.phoneNumerTextField)
        self.view.addSubview(self.phoneNumerLine)
        self.view.addSubview(self.verfCodeTextField)
        self.view.addSubview(self.verfCodeLine)
        self.view.addSubview(self.newPsdTextField)
        self.view.addSubview(self.newPsdLine)
        
        self.view.addSubview(self.commitButton)
    }
    
    private func createConstrains() {
        
        self.phoneNumerTextField.autoAlignAxis(toSuperviewAxis: .vertical)
        self.phoneNumerTextField.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        self.phoneNumerTextField.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        self.phoneNumerTextField.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        self.phoneNumerTextField.autoSetDimension(.height, toSize: 50)
        
        self.phoneNumerLine.autoPinEdge(.left, to: .left, of: self.phoneNumerTextField)
        self.phoneNumerLine.autoPinEdge(.right, to: .right, of: self.phoneNumerTextField)
        self.phoneNumerLine.autoPinEdge(.bottom, to: .bottom, of: self.phoneNumerTextField)
        self.phoneNumerLine.autoSetDimension(.height, toSize: 0.5)
        
        self.verfCodeTextField.autoAlignAxis(toSuperviewAxis: .vertical)
        self.verfCodeTextField.autoPinEdge(.top, to: .bottom, of: self.phoneNumerTextField)
        self.verfCodeTextField.autoPinEdge(.left, to: .left, of: self.phoneNumerTextField)
        self.verfCodeTextField.autoPinEdge(.right, to: .right, of: self.phoneNumerTextField)
        self.verfCodeTextField.autoMatch(.height,
                                         to: .height,
                                         of: self.phoneNumerTextField,
                                         withMultiplier: 1,
                                         relation: .equal)
        
        self.verfCodeLine.autoPinEdge(.left, to: .left, of: self.verfCodeTextField)
        self.verfCodeLine.autoPinEdge(.right, to: .right, of: self.verfCodeTextField)
        self.verfCodeLine.autoPinEdge(.bottom, to: .bottom, of: self.verfCodeTextField)
        self.verfCodeLine.autoMatch(.height,
                                    to: .height,
                                    of: self.phoneNumerLine,
                                    withMultiplier: 1,
                                    relation: .equal)
        
        self.newPsdTextField.autoAlignAxis(toSuperviewAxis: .vertical)
        self.newPsdTextField.autoPinEdge(.top, to: .bottom, of: self.verfCodeTextField)
        self.newPsdTextField.autoPinEdge(.left, to: .left, of: self.verfCodeTextField)
        self.newPsdTextField.autoPinEdge(.right, to: .right, of: self.verfCodeTextField)
        self.newPsdTextField.autoMatch(.height,
                                       to: .height,
                                       of: self.verfCodeTextField,
                                       withMultiplier: 1,
                                       relation: .equal)
        
        self.newPsdLine.autoPinEdge(.left, to: .left, of: self.newPsdTextField)
        self.newPsdLine.autoPinEdge(.right, to: .right, of: self.newPsdTextField)
        self.newPsdLine.autoPinEdge(.bottom, to: .bottom, of: self.newPsdTextField)
        self.newPsdLine.autoMatch(.height,
                                  to: .height,
                                  of: self.phoneNumerLine,
                                  withMultiplier: 1,
                                  relation: .equal)
        
        self.commitButton.autoAlignAxis(toSuperviewAxis: .vertical)
        self.commitButton.autoPinEdge(.top,
                                      to: .bottom,
                                      of: self.newPsdTextField,
                                      withOffset: 40.0)
        self.commitButton.autoPinEdge(toSuperviewEdge: .left, withInset: 40)
        self.commitButton.autoPinEdge(toSuperviewEdge: .right, withInset: 40)
        self.commitButton.autoMatch(.height,
                                    to: .height,
                                    of: self.newPsdTextField,
                                    withMultiplier: 1,
                                    relation: .equal)
    }
    
    private func createReacts() {
        
    }
}

extension RegistViewController {
    func onRegistCliccked() {
        
    }
}
