//
//  HomeViewController.swift
//  SkyTool
//
//  Created by tree on 2019/3/21.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit
import PureLayout
import XMLCoder

class HomeViewController: UIViewController {
    
    let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView.init(frame: .zero, collectionViewLayout: self.flowLayout)
        view.backgroundColor = UIColor.background
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    lazy var controller: HomeController = {
        HomeController(sourceController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.background
        self.setupViews()
        self.createConstraints()
    }
    
    func setupViews() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.collectionView.register(UINib.init(nibName: "ToolCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "ToolCollectionViewCell")
        self.view.addSubview(self.collectionView)
        let rightItem = UIBarButtonItem.init(barButtonSystemItem: .add,
                                             target: self.controller,
                                             action: #selector(HomeController.onAddClicked(_:)))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    func createConstraints() {
        self.collectionView.autoPinEdgesToSuperviewSafeArea()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        let supported = UIInterfaceOrientationMask.allButUpsideDown
        return supported
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToolCollectionViewCell",
                                                            for: indexPath) as? ToolCollectionViewCell else {
            fatalError()
        }
        cell.titleLabel.text = "我是\(indexPath)"
        
        cell.contentView.backgroundColor = UIColor.randomColor()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.controller.onItemClicked(indexPath.item)
//        self.controller.toOpenSheet()
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var colum: CGFloat = 2
        if UIDevice.current.isPad { colum = 3 }
        let width = collectionView.bounds.width / colum - 10
        let size = CGSize.init(width: width, height: width * CGFloat(0.55))
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
