//
//  PhotoCollectionViewController.swift
//  SkyTool
//
//  Created by tree on 2019/4/16.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import UIKit
import Photos
import PureLayout

class PhotoCollectionViewController: UIViewController {
    
    var fetch: PHFetchResult<PHAsset>
    
    var coordinator: PhotoPickerCoordinator
    
    var selectedIndex: Set<IndexPath> = []
    
    var colum: Int {
        var colum: Int = 3
        if UIDevice.current.isPad { colum = 4 }
        return colum
    }
    
    lazy var gridThumbSize: CGSize = {
        var colum: CGFloat = CGFloat(self.colum)
        if UIDevice.current.isPad { colum = 3 }
        let width = (collectionView.bounds.width / colum) - 3.0
        let size = CGSize.init(width: width, height: width)
        return size
    }()
    
    let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView.init(frame: .zero, collectionViewLayout: self.flowLayout)
        view.backgroundColor = UIColor.background
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    lazy var cancelBarButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancel))
    }()
    
    lazy var confirmBarButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(confirm))
    }()
    
    init(_ fetchResult: PHFetchResult<PHAsset>, coordinator: PhotoPickerCoordinator) {
        self.fetch = fetchResult
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.background
        self.navigationItem.largeTitleDisplayMode = .never
        self.setupViews()
        self.createConstraints()
    }
    
    func setupViews() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.collectionView.register(UINib.init(nibName: "PhotoCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        self.view.addSubview(self.collectionView)
        self.navigationItem.rightBarButtonItem = self.cancelBarButton
    }
    
    func createConstraints() {
        self.collectionView.autoPinEdgesToSuperviewSafeArea()
    }
    
    func updateRightItem() {
        if self.selectedIndex.count > 0 {
            self.confirmBarButton.title = "确认(\(self.selectedIndex.count))"
            self.navigationItem.rightBarButtonItem = self.confirmBarButton
        } else {
            self.navigationItem.rightBarButtonItem = self.cancelBarButton
        }
    }
    
    @objc func confirm() {
        var assetes = [PHAsset]()
        
        self.fetch.enumerateObjects { (asset, idx, _) in
            if let _ = self.selectedIndex.first(where: {$0.item == idx }) {
                assetes.append(asset)
            }
        }
        self.coordinator.selectAssets(assetes)
        self.coordinator.onCancel(from: self)
    }
    
    @objc func cancel() {
        self.coordinator.onCancel(from: self)
    }
}

extension PhotoCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetch.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell",
                                                            for: indexPath) as? PhotoCollectionViewCell else {
                                                                fatalError()
        }
        let asset = self.fetch.object(at: indexPath.item)
        PHCachingImageManager().getImage(asset: asset, size: self.gridThumbSize) { (image) in
            cell.imageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell else { return }
        if self.selectedIndex.contains(indexPath) {
            self.selectedIndex.remove(indexPath)
            cell.imageView.layer.borderWidth = 0
        } else {
            if self.selectedIndex.count >= self.coordinator.options.maxiumSelecteCount {
                toast(content: "toast.picker.image.maxcount".localized)
                return
            }
            self.selectedIndex.insert(indexPath)
            cell.imageView.layer.borderWidth = self.coordinator.options.selectedBorderWidth
            cell.imageView.layer.borderColor = self.coordinator.options.selectedBorderColor.cgColor
        }
        self.updateRightItem()
    }
}

extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.gridThumbSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.01
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.01
    }
}

extension PHCachingImageManager {
    func getImage(asset: PHAsset, size: CGSize, completion: @escaping (UIImage?) -> Void) {
        let maxSize = size
        let factor = CGFloat(asset.pixelHeight)/CGFloat(asset.pixelWidth)
        let pixcelWidth = maxSize.width * UIScreen.main.scale
        let pixcelHeight = CGFloat(pixcelWidth) * factor
        
        self.requestImage(for: asset, targetSize: CGSize(width: pixcelWidth, height: pixcelHeight), contentMode: .aspectFit, options: nil) { (tempImage, info) in
            if let info = info as? [String: Any],
                let image = tempImage {
                let canceled = info[PHImageCancelledKey] as? Bool
                let error = info[PHImageErrorKey] as? NSError
                if canceled == nil && error == nil {
                    completion(image)
                }
            }
        }
    }
}
