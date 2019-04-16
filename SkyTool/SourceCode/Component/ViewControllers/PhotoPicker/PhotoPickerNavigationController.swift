//
//  PhotoPickerNavigationController.swift
//  SkyTool
//
//  Created by tree on 2019/4/16.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import UIKit
import Photos

class PhotoPickerNavigationController: UINavigationController {
    
    var coordinator: PhotoPickerCoordinator?
    
    init(_ coordinator: PhotoPickerCoordinator) {
        self.coordinator = coordinator
        let rootViewController = PhotoAlbumListViewController(coordinator)
        super.init(rootViewController: rootViewController)
        self.navigationItem.largeTitleDisplayMode = .never
        let currentType = PHAssetCollectionSubtype.smartAlbumUserLibrary
        let result = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: currentType, options: nil)
        guard result.count > 0,
            let collection = result.firstObject,
            let models = self.fetchAssertModels(collection: collection) else { return }
        let collectionViewController = PhotoCollectionViewController(models, coordinator: coordinator)
        collectionViewController.title = collection.localizedTitle
        self.pushViewController(collectionViewController, animated: false)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    private func fetchAssertModels(collection: PHAssetCollection) -> PHFetchResult<PHAsset>? {
        let fetchResult = PHAsset.fetchAssets(in: collection, options: FetchOp())
        return fetchResult.count > 0 ? fetchResult : nil
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
    }
}

class FetchOp: PHFetchOptions {
    override init() {
        super.init()
        self.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        self.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: .init(false))]
    }
}
