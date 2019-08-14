//
//  RegisterViewModel.swift
//  SkyTool
//
//  Created by tree on 2019/8/4.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RegisterViewModel: ViewControllerViewModelProtocol {
    
    var bag = DisposeBag()
    
    var title: BehaviorRelay<String>
    
    var backgroundColor = BehaviorRelay<UIColor>.init(value: .white)
    
    var showHud = BehaviorRelay<HUDType>.init(value: .none)
    
    var isNavigationBarHidden = BehaviorRelay<Bool>.init(value: false)
    
    var viewDidLoad = PublishSubject<UIViewController>.init()

    var viewWillAppear = PublishSubject<Bool>()
    
    var viewDidAppear = PublishSubject<Bool>()
    
    var viewWillDisappear = PublishSubject<Bool>()
    
    var viewDidDisappear = PublishSubject<Bool>()
    
    init(title: String) {
        self.title = BehaviorRelay<String>.init(value: title)
        createReact()
    }
    
    func createReact() {
        showHud.accept(.indicator(nil))
        delay(10, closure: {
            self.showHud.accept(.none)
        })
        
    }
}
