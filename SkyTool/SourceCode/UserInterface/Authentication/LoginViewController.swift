//
//  LoginViewController.swift
//  HuBeiECarSalerClient
//
//  Created by tree on 2019/1/5.
//  Copyright © 2019 tree. All rights reserved.
//

import UIKit
import YYKit

class LoginViewController: UIViewController {
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView.init()
        let image = UIImage.init(named: "AppIcon60x60")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var userImageView: UIImageView = {
        let imageView = UIImageView.init()
        let image = UIImage.init(named: "people")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.size = CGSize.init(width: 50.0, height: 30.0)
        return imageView
    }()
    
    private lazy var userNameTextField: UITextField = {
        let textfield = UITextField.init()
        textfield.leftView = userImageView
        textfield.leftViewMode = .always
        textfield.font = UIFont.normalLightFont
        textfield.textColor = UIColor.textBlack
        let attr = NSMutableAttributedString.init(string: "请输入您的账号")
        attr.font = UIFont.normalLightFont
        attr.color = UIColor.textPlaceholder
        textfield.attributedPlaceholder = attr
        return textfield
    }()
    
    private lazy var userNameLine: UIView = {
        let line = UIView.init()
        line.backgroundColor = UIColor.separator
        return line
    }()
    
    private var lockImageView: UIImageView = {
        let imageView = UIImageView.init()
        let image = UIImage.init(named: "lock")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.size = CGSize.init(width: 50.0, height: 30.0)
        return imageView
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textfield = UITextField.init()
        textfield.leftView = lockImageView
        textfield.leftViewMode = .always
        textfield.font = UIFont.normalLightFont
        textfield.textColor = UIColor.textBlack
        textfield.isSecureTextEntry = true
        let attr = NSMutableAttributedString.init(string: "请输入您的密码")
        attr.font = UIFont.normalLightFont
        attr.color = UIColor.textPlaceholder
        textfield.attributedPlaceholder = attr
        return textfield
    }()
    
    private lazy var passwordLine: UIView = {
        let line = UIView.init()
        line.backgroundColor = UIColor.separator
        return line
    }()
    
    private lazy var commitButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setTitle("确定", for: .normal)
        button.titleLabel?.font = UIFont.normalRegularFont
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
                                    tapAction: { [unowned self] (_, _, _, _) in
                                        self.forgotPasswordClicked()
            })
            return append
            }())
        attr.alignment = .center
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
        self.createReacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func forgotPasswordClicked() {
        
    }
    
    private func setupSubViews() {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.userNameTextField)
        self.view.addSubview(self.userNameLine)
        self.view.addSubview(self.passwordTextField)
        self.view.addSubview(self.passwordLine)
        self.view.addSubview(self.commitButton)
        self.view.addSubview(self.infoLabel)
        self.userNameLine.isHidden = true
        self.passwordLine.isHidden = true
    }
    
    private func createConstrains() {
        self.logoImageView.autoAlignAxis(toSuperviewAxis: .vertical)
        self.logoImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 140)
        self.logoImageView.autoSetDimensions(to: CGSize.init(width: 100, height: 100))
        
        self.userNameTextField.autoAlignAxis(toSuperviewAxis: .vertical)
        self.userNameTextField.autoPinEdge(.top, to: .bottom, of: self.logoImageView, withOffset: 40)
        self.userNameTextField.autoPinEdge(toSuperviewEdge: .left, withInset: 51)
        self.userNameTextField.autoPinEdge(toSuperviewEdge: .right, withInset: 51)
        self.userNameTextField.autoSetDimension(.height, toSize: 50)
        
        self.userNameLine.autoPinEdge(.left, to: .left, of: self.userNameTextField)
        self.userNameLine.autoPinEdge(.right, to: .right, of: self.userNameTextField)
        self.userNameLine.autoPinEdge(.bottom, to: .bottom, of: self.userNameTextField)
        self.userNameLine.autoSetDimension(.height, toSize: 0.5)
        
        self.passwordTextField.autoAlignAxis(toSuperviewAxis: .vertical)
        self.passwordTextField.autoPinEdge(.top, to: .bottom, of: self.userNameTextField)
        self.passwordTextField.autoPinEdge(.left, to: .left, of: self.userNameTextField)
        self.passwordTextField.autoPinEdge(.right, to: .right, of: self.userNameTextField)
        self.passwordTextField.autoMatch(.height,
                                         to: .height,
                                         of: self.userNameTextField,
                                         withMultiplier: 1,
                                         relation: .equal)
        
        self.passwordLine.autoPinEdge(.left, to: .left, of: self.passwordTextField)
        self.passwordLine.autoPinEdge(.right, to: .right, of: self.passwordTextField)
        self.passwordLine.autoPinEdge(.bottom, to: .bottom, of: self.passwordTextField)
        self.passwordLine.autoMatch(.height,
                                    to: .height,
                                    of: self.userNameLine,
                                    withMultiplier: 1,
                                    relation: .equal)
        
        self.commitButton.autoAlignAxis(toSuperviewAxis: .vertical)
        self.commitButton.autoPinEdge(.top, to: .bottom, of: self.passwordTextField, withOffset: 40.0)
        self.commitButton.autoPinEdge(toSuperviewEdge: .left, withInset: 40)
        self.commitButton.autoPinEdge(toSuperviewEdge: .right, withInset: 40)
        self.commitButton.autoMatch(.height,
                                    to: .height,
                                    of: self.passwordTextField,
                                    withMultiplier: 1,
                                    relation: .equal)
        
        self.infoLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        self.infoLabel.autoPinEdge(.top, to: .bottom, of: self.commitButton, withOffset: 30.0)
        self.infoLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 30)
        self.infoLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 30)
    }
    
    private func createReacts() {
        self.commitButton.addTarget(self,
                                    action: #selector(onCommitButtonClicked),
                                    for: .touchUpInside)
    }
    
    private func pushToRegist() {
        
    }
}

extension LoginViewController {
    @objc func onCommitButtonClicked() {
        self.coordinator.startLogin(name: self.userNameTextField.text ?? "",
                                    password: self.passwordTextField.text ?? "")
    }
}
