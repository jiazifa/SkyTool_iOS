//
//  SettingsCell.swift
//  HuBeiECarSalerClient
//
//  Created by tree on 2018/12/28.
//  Copyright © 2018 tree. All rights reserved.
//

import UIKit
import PureLayout

enum SettingsCellPreview {
    case none
    case text(String)
    case image(UIImage)
    case color(UIColor)
}

protocol SettingsCellType: class {
    var titleText: String { get set }
    var preview: SettingsCellPreview {get set}
    var titleColor: UIColor {get set}
    var cellColor: UIColor? {get set}
    var descriptor: SettingsCellDescriptorType? {get set}
}

@objcMembers class SettingsTableCell: UITableViewCell, SettingsCellType {
    
    let iconImageView = UIImageView()
    
    public let cellNameLabel: UILabel = {
        let label = UILabel()
        label.font = .normalLightFont
        label.setContentCompressionResistancePriority(.defaultHigh,
                                                      for: .horizontal)
        return label
    }()
    
    let valueLabel = UILabel()
    
    var badgeLabel = UILabel()
    
    let imagePreview = UIImageView()
    
    let separatorLine = UIView()
    
    let topSeparatorLine = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var titleText: String = "" {
        didSet {
            cellNameLabel.text = titleText
        }
    }
    
    var preview: SettingsCellPreview = .none {
        didSet {
            switch preview {
            case .text(let string):
                valueLabel.text = string
                badgeLabel.text = ""
                imagePreview.image = .none
                imagePreview.backgroundColor = UIColor.clear
                imagePreview.accessibilityValue = nil
                imagePreview.isAccessibilityElement = false
                
            case .image(let image):
                valueLabel.text = ""
                badgeLabel.text = ""
                imagePreview.image = image
                imagePreview.backgroundColor = UIColor.clear
                imagePreview.accessibilityValue = "image"
                imagePreview.isAccessibilityElement = true
                
            case .color(let color):
                valueLabel.text = ""
                badgeLabel.text = ""
                imagePreview.image = .none
                imagePreview.backgroundColor = color
                imagePreview.accessibilityValue = "color"
                imagePreview.isAccessibilityElement = true
                
            case .none:
                valueLabel.text = ""
                badgeLabel.text = ""
                imagePreview.image = .none
                imagePreview.backgroundColor = UIColor.clear
                imagePreview.accessibilityValue = nil
                imagePreview.isAccessibilityElement = false
            }
        }
    }
    
    var isFirst: Bool = false {
        didSet {
            topSeparatorLine.isHidden = !isFirst
        }
    }
    
    var titleColor: UIColor = UIColor.white {
        didSet {
            cellNameLabel.textColor = titleColor
        }
    }
    
    var cellColor: UIColor? {
        didSet {
            backgroundColor = cellColor
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        updateBackgroundColor()
    }
    
    var descriptor: SettingsCellDescriptorType?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        setupAccessibiltyElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        setupAccessibiltyElements()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        preview = .none
        iconImageView.image = nil
    }
    
    func setup() {
        backgroundColor = UIColor.clear
        backgroundView = UIView()
        selectedBackgroundView = UIView()
        
        iconImageView.contentMode = .center
        contentView.addSubview(iconImageView)
        iconImageView.autoPinEdge(toSuperviewEdge: .leading, withInset: 8.0)
        iconImageView.autoMatch(.height, to: .width, of: iconImageView)
        iconImageView.autoSetDimension(.width, toSize: 16, relation: .lessThanOrEqual)
        iconImageView.autoAlignAxis(toSuperviewMarginAxis: .horizontal)
        
        contentView.addSubview(cellNameLabel)
        cellNameLabel.setContentHuggingPriority(UILayoutPriority.required,
                                                for: .horizontal)
        cellNameLabel.autoPinEdge(.leading, to: .trailing, of: iconImageView, withOffset: 10.0)
        cellNameLabel.autoPinEdge(toSuperviewMargin: .trailing, relation: .greaterThanOrEqual)
        cellNameLabel.autoAlignAxis(toSuperviewMarginAxis: .horizontal)
        
        valueLabel.textColor = UIColor.lightGray
        valueLabel.font = UIFont.systemFont(ofSize: 17)
        valueLabel.textAlignment = .right
        
        contentView.addSubview(valueLabel)
        
        badgeLabel.font = FontSpec(.small, .medium).font
        badgeLabel.textAlignment = .center
        badgeLabel.textColor = UIColor.black
        
        let trailingBoundaryView = accessoryView ?? contentView
        valueLabel.autoPinEdge(.trailing, to: .trailing, of: trailingBoundaryView, withOffset: -10, relation: .greaterThanOrEqual)
        valueLabel.autoAlignAxis(toSuperviewMarginAxis: .horizontal)
        valueLabel.autoPinEdge(.leading, to: .trailing, of: cellNameLabel)
        
        imagePreview.clipsToBounds = true
        imagePreview.layer.cornerRadius = 15
        imagePreview.contentMode = .scaleAspectFill
        imagePreview.accessibilityIdentifier = "imagePreview"
        contentView.addSubview(imagePreview)
        
        imagePreview.autoSetDimension(.height, toSize: 30.0, relation: .greaterThanOrEqual)
        imagePreview.autoSetDimension(.width, toSize: 30.0, relation: .greaterThanOrEqual)
        imagePreview.autoAlignAxis(toSuperviewMarginAxis: .horizontal)
        imagePreview.autoPinEdge(.trailing, to: .trailing, of: trailingBoundaryView, withOffset: -16)
        
        separatorLine.backgroundColor = UIColor.color("#F5F5F5")
        separatorLine.isAccessibilityElement = false
        addSubview(separatorLine)
        separatorLine.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        separatorLine.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
        separatorLine.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        separatorLine.autoSetDimension(.height, toSize: 0.5)
        
        topSeparatorLine.backgroundColor = UIColor.color("#F5F5F5")
        topSeparatorLine.isAccessibilityElement = false
        addSubview(topSeparatorLine)
        
        topSeparatorLine.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        topSeparatorLine.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
        topSeparatorLine.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        topSeparatorLine.autoSetDimension(.height, toSize: 0.5)
        
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 56).isActive = true
    }
    
    func setupAccessibiltyElements() {
        var currentElements = accessibilityElements ?? []
        currentElements.append(contentsOf: [cellNameLabel, valueLabel, imagePreview])
        accessibilityElements = currentElements
    }
    
    func updateBackgroundColor() {
        if cellColor != nil {
            return
        }
        
        if isHighlighted && selectionStyle != .none {
            backgroundColor = UIColor(white: 0, alpha: 0.2)
            badgeLabel.textColor = UIColor.black
        } else {
            backgroundColor = UIColor.clear
        }
    }
}

@objcMembers class SettingsGroupCell: SettingsTableCell {
    override func setup() {
        super.setup()
        accessoryType = .disclosureIndicator
    }
}

@objcMembers class SettingsButtonCell: SettingsTableCell {
    override func setup() {
        super.setup()
        cellNameLabel.textColor = UIColor.black
    }
}

@objcMembers class SettingsToggleCell: SettingsTableCell {
    var switchView: UISwitch!
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        shouldGroupAccessibilityChildren = false
        switchView = UISwitch.init()
        switchView.addTarget(self, action: #selector(onSwitchChanged(_:)), for: .valueChanged)
        accessoryView = switchView
    }
    
    @objc func onSwitchChanged(_ sender: UIResponder) {
        descriptor?.select(SettingsPropertyValue(switchView.isOn))
    }
}

@objcMembers class SettingsStaticTextTableCell: SettingsTableCell {
    override func setup() {
        super.setup()
        cellNameLabel.numberOfLines = 0
        cellNameLabel.textAlignment = .justified
    }
}

class SettingsValueCell: SettingsTableCell {
    override var descriptor: SettingsCellDescriptorType? {
        willSet {
            if let propertyDescriptor = descriptor as? SettingsPropertyCellDescriptorType {
                let propertyName = propertyDescriptor.settingsProperty.propertyName
                let notificationString = propertyName.changeNotificationName
                let name = NSNotification.Name(notificationString)
                NotificationCenter.default.removeObserver(self, name: name, object: nil)
            }
        }
        didSet {
            if let propertyDescriptor = descriptor as? SettingsPropertyCellDescriptorType {
                let propertyName = propertyDescriptor.settingsProperty.propertyName
                let notificationString = propertyName.changeNotificationName
                let name = NSNotification.Name(rawValue: notificationString)
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(onPropertyChanged(_:)),
                                                       name: name,
                                                       object: nil)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Properties observing
    
    @objc func onPropertyChanged(_ notification: Notification) {
        descriptor?.featureCell(self)
    }
}

class SettingsTextCell: SettingsTableCell, UITextFieldDelegate {
    var textInput: UITextField!
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        
        textInput = TailEditingTextField.init(frame: .zero)
        textInput.delegate = self
        textInput.textAlignment = .right
        textInput.textColor = UIColor.lightGray
        textInput.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        contentView.addSubview(textInput)
        createConstraints()
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(onCellSelected(_:)))
        contentView.addGestureRecognizer(tap)
    }
    
    func createConstraints() {
        let textInputSpacing = CGFloat(-16)
        let trailingBoundaryView = accessoryView ?? contentView
        
        textInput.autoPinEdge(toSuperviewEdge: .top, withInset: 8)
        textInput.autoPinEdge(toSuperviewEdge: .bottom, withInset: 8)
        textInput.autoPinEdge(.right, to: .right, of: trailingBoundaryView, withOffset: textInputSpacing)
        NSLayoutConstraint.activate([
            cellNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: textInput.leadingAnchor, constant: textInputSpacing)
        ])
    }
    
    override func setupAccessibiltyElements() {
        super.setupAccessibiltyElements()
        
        var currentElements = accessibilityElements ?? []
        currentElements.append(textInput)
        accessibilityElements = currentElements
    }
    
    @objc func onCellSelected(_ tap: UITapGestureRecognizer) {
        if !textInput.isFirstResponder {
            textInput.becomeFirstResponder()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.rangeOfCharacter(from: CharacterSet.newlines) != .none {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            descriptor?.select(SettingsPropertyValue.string(value: text))
        }
    }
}
