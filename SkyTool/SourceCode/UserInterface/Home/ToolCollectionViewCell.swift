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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.font = UIFont.normalSemiboldFont
        self.contentView.layer.cornerRadius = 10
        self.contentView.clipsToBounds = true
    }

    @IBAction func moreButtonClicked(_ sender: UIButton) {
    }
}
