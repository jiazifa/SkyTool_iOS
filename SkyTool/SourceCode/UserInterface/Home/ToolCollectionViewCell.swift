//
//  ToolCollectionViewCell.swift
//  SkyTool
//
//  Created by tree on 2019/3/21.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

class ToolCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var optionButton: UIButton!
    
    var onOptionEvent = Delegate<Void, Void>()
    
    var isEditing: Bool = false {
        didSet { updateEditState(isEditing) }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.font = UIFont.normalSemiboldFont
        self.contentView.layer.cornerRadius = 10
        self.contentView.clipsToBounds = true
    }

    @IBAction func moreButtonClicked(_ sender: UIButton) {
        self.onOptionEvent.call()
    }
    
    func updateEditState(_ isEdit: Bool) {
        self.optionButton.isHidden = !isEdit
    }
}
