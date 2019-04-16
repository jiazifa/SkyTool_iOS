//
//  PhotoAlbumListViewController.swift
//  SkyTool
//
//  Created by tree on 2019/4/16.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import UIKit
import Photos

class PhotoAlbumListViewController: UITableViewController {
    
    var coordinator: PhotoPickerCoordinator
    
    var albums = [FetchModel]()
    
    init(_ coordinator: PhotoPickerCoordinator) {
        self.coordinator = coordinator
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.background
        PHPhotoLibrary.shared().register(self)
        setupTableView()
        setupNavigationBar()
        loadAlbums(true)
    }
    
    private func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(navDismiss))
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    @objc private func navDismiss() {
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    private func setupTableView() {
        self.tableView.rowHeight = PhotoListCell.cellAlbumHeight
        self.tableView.separatorColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.register(PhotoListCell.self, forCellReuseIdentifier: PhotoListCell.reuseIdentifier)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    fileprivate func loadAlbums(_ replace: Bool) {
        if replace {
            self.albums.removeAll()
        }
        
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        print("smartAlbums.count:\(smartAlbums.count)")
        for i in 0 ..< smartAlbums.count  {//14 (contains `Recently Deleted`)
            self.filterFetchResult(collection: smartAlbums[i])
        }
        
        let topUserLibraryList = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        for i in 0 ..< topUserLibraryList.count {
            if let topUserAlbumItem = topUserLibraryList[i] as? PHAssetCollection {
                self.filterFetchResult(collection: topUserAlbumItem)
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func filterFetchResult(collection: PHAssetCollection) {
        let fetchResult = PHAsset.fetchAssets(in: collection, options: FetchOp())
        if fetchResult.count > 0 {
            self.albums.append(FetchModel(result: fetchResult as! PHFetchResult<PHObject> ,
                                          name: collection.localizedTitle,
                                          assetType: collection.assetCollectionSubtype))
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoListCell.reuseIdentifier,
                                                 for: indexPath) as! PhotoListCell
        cell.asset = self.albums[indexPath.row].fetchResult.firstObject as? PHAsset
        cell.albumTitleAndCount = (self.albums[indexPath.row].name,
                                   self.albums[indexPath.row].fetchResult.count)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let result =  albums[indexPath.row].fetchResult as? PHFetchResult<PHAsset> else { return }
        let vc = PhotoCollectionViewController(result,
                                               coordinator: self.coordinator)
        vc.title = self.albums[indexPath.row].name
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PhotoAlbumListViewController : PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        loadAlbums(true)
    }
}
