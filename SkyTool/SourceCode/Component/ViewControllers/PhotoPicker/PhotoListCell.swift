//
//  PhotoListCell.swift
//  SkyTool
//
//  Created by tree on 2019/4/16.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import UIKit
import Photos

class FetchModel {
    var fetchResult: PHFetchResult<PHObject>!
    var assetType: PHAssetCollectionSubtype!
    var name: String!
    
    init(result: PHFetchResult<PHObject>,name: String?, assetType: PHAssetCollectionSubtype){
        self.fetchResult = result
        self.name = name
        self.assetType = assetType
    }
}

class PhotoListCell: UITableViewCell {
    static let cellAlbumHeight: CGFloat = 70.0
    
    class func cellWithTableView(_ tableView: UITableView) -> PhotoListCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: PhotoListCell.reuseIdentifier) as? PhotoListCell
        if cell == nil {
            cell = PhotoListCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: PhotoListCell.reuseIdentifier)
        }
        return cell!
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {
        self.layoutMargins = UIEdgeInsets.zero
        let bgView = UIView()
        bgView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        self.selectedBackgroundView = bgView
        
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        
        self.contentView.addSubview(coverImage)
        self.contentView.addSubview(photoTitle)
        self.contentView.addSubview(photoNum)
        
        addConstraint(NSLayoutConstraint(item: photoTitle,attribute: .centerY,relatedBy: .equal,toItem: coverImage,attribute: .centerY,multiplier: 1.0,constant: 0))
        addConstraint(NSLayoutConstraint(item: photoTitle,attribute: .leading,relatedBy: .equal,toItem: coverImage,attribute: .trailing,multiplier: 1.0,constant: 10))
        
        addConstraint(NSLayoutConstraint(item: photoNum,attribute: .centerY,relatedBy: .equal,toItem: coverImage,attribute: .centerY,multiplier: 1.0,constant: 0))
        addConstraint(NSLayoutConstraint(item: photoNum,attribute: .leading,relatedBy: .equal,toItem: photoTitle,attribute: .trailing,multiplier: 1.0,constant: 10))
    }
    
    func renderData(_ result:PHFetchResult<AnyObject>, label: String?) {
        self.photoTitle.text = label
        self.photoNum.text = "(" + String(result.count) + ")"
        if result.count > 0 {
            if let firstImageAsset = result[0] as? PHAsset {
                let realSize = self.coverImage.frame.width * UIScreen.main.scale
                let size = CGSize(width:realSize, height: realSize)
                let imageOptions = PHImageRequestOptions()
                imageOptions.resizeMode = .exact
                PHImageManager.default().requestImage(for: firstImageAsset, targetSize: size, contentMode: .aspectFill, options: imageOptions, resultHandler: { image, info in
                    self.coverImage.image = image
                })
            }
        }
    }
    
    var asset: PHAsset? {
        willSet {
            if newValue == nil {
                return
            }
            let realSize = self.coverImage.frame.width * UIScreen.main.scale
            let size = CGSize(width:realSize, height: realSize)
            PHCachingImageManager.default().requestImage(for: newValue!, targetSize: size, contentMode: .aspectFill, options: nil, resultHandler: { (img, _) in
                self.coverImage.image = img
            })
        }
    }
    
    var albumTitleAndCount: (String?, Int)? {
        willSet {
            if newValue == nil {
                return
            }
            self.photoTitle.text = (newValue!.0 ?? "")
            self.photoNum.text = "(\(String(describing: newValue!.1)))"
        }
    }
    
    private lazy var coverImage: UIImageView = {
        let iv = UIImageView()
        iv.frame = CGRect(x: 0,y: 0,width: PhotoListCell.cellAlbumHeight, height: PhotoListCell.cellAlbumHeight)
        return iv
    }()
    
    private lazy var photoTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var photoNum: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
}
