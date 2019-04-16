//
//  PhotoPickerCoordinator.swift
//  SkyTool
//
//  Created by tree on 2019/4/16.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import UIKit
import Photos

protocol PhotoPickerDelegate: class {
    func onImageSelecteFinished(_ images: [PHAsset])
}


class PhotoPickerCoordinator {
    
    weak var delegate: PhotoPickerDelegate?
    
    var options: PhotoPickerOptions = PhotoPickerOptions.default
    
    init() {}
    
    public func selectAssets(_ assetes: [PHAsset]) {
        self.delegate?.onImageSelecteFinished(assetes)
    }
    
    public func onCancel(from sourceViewController: UIViewController) {
        sourceViewController.navigationController?.dismiss(animated: true, completion: nil)
    }
}
