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
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var updatelabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rssTitleLabel.font = UIFont.normalSemiboldFont
        rssTitleLabel.textColor = UIColor.textBlack
        
        updatelabel.text = ""
        updatelabel.font = UIFont.smallFont
        updatelabel.textColor = UIColor.textDimmed
        
        domainLabel.text = ""
        domainLabel.font = UIFont.smallFont
        domainLabel.textColor = UIColor.textDimmed
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
