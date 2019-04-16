//
//  PickerImageController.swift
//  SkyTool
//
//  Created by tree on 2019/4/16.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import Photos
import UIKit

typealias ImagePickControllerResultBlock = ((_ images: [UIImage]?) -> Void)

class PickerImageController: NSObject {
    unowned var hostViewController: UIViewController
    
    var coordinator: PhotoPickerCoordinator = PhotoPickerCoordinator()
    
    var imagePickerViewController: UIImagePickerController = UIImagePickerController.init()
    
    lazy var photoPickerViewController: PhotoPickerNavigationController = {
        return PhotoPickerNavigationController(self.coordinator)
    }()
    
    var alertController: UIAlertController = UIAlertController.init(title: nil,
                                                                    message: nil,
                                                                    preferredStyle: .actionSheet)
    
    
    var result: ImagePickControllerResultBlock!
    
    var options: PhotoPickerOptions {
        set { self.coordinator.options = newValue }
        get { return self.coordinator.options }
    }
    
    @objc(initWithHostViewController:)
    init(hostViewController: UIViewController) {
        self.hostViewController = hostViewController
        super.init()
        self.coordinator.delegate = self
        self.setupAlertController()
    }
    
    func setupAlertController() {
        let libAction = UIAlertAction.init(title: "图库", style: .default) { (_) in
            self.openImageController(by: .photoLibrary)
        }
        self.alertController.addAction(libAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction.init(title: "拍照", style: .default) { (_) in
                self.openImageController(by: .camera)
            }
            self.alertController.addAction(cameraAction)
        }
        
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (_) in }
        self.alertController.addAction(cancelAction)
    }
    
    public func beginPick(result: @escaping ImagePickControllerResultBlock) {
        self.result = result
        self.hostViewController.present(self.alertController, animated: true, completion: nil)
    }
    
    func openImageController(by source: UIImagePickerController.SourceType) {
        switch source {
        case .camera:
            self.imagePickerViewController.delegate = self
            self.imagePickerViewController.allowsEditing = true
            self.imagePickerViewController.sourceType = source
            self.hostViewController.present(self.imagePickerViewController, animated: true, completion: nil)
        case .photoLibrary, .savedPhotosAlbum:
            self.hostViewController.present(self.photoPickerViewController, animated: true, completion: nil)
            break
        }
    }
}

extension PickerImageController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.result([image])
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        self.result(nil)
    }
}

extension PickerImageController: PhotoPickerDelegate {
    func onImageSelecteFinished(_ images: [PHAsset]) {
        var targetImages = [UIImage]()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.version = .original
        images.forEach { (asset) in
            PHCachingImageManager().requestImageData(for: asset, options: options, resultHandler: { (data, _, _, _) in
                if let d = data,
                    let img = UIImage.init(data: d) {
                    targetImages.append(img)
                }
            })
        }
        self.result(targetImages)
        self.photoPickerViewController.dismiss(animated: true, completion: nil)
    }
}

extension UIAlertController {
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.supportedOrientations
    }
    
    open override var shouldAutorotate: Bool {
        return true
    }
}
