//
//  RssListCell.swift
//  SkyTool
//
//  Created by tree on 2019/8/13.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

class RssListCell: UITableViewCell {

    @IBOutlet weak var rssTitleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var updatelabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rssTitleLabel.font = UIFont.normalSemiboldFont
        rssTitleLabel.textColor = UIColor.textBlack
        
        updatelabel.font = UIFont.smallFont
        updatelabel.textColor = UIColor.textDimmed
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
