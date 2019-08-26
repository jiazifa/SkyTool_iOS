//
//  AddMissionViewModel.swift
//  SkyTool
//
//  Created by tree on 2019/8/17.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddMissionViewModel: RxBaseViewModel {
    
    override init() {
        super.init()
        title.accept("添加任务")
        
        viewDidLoad.subscribe({ [weak self] event in
            self?.viewController = event.element
        }).disposed(by: bag)
    }
    
}
