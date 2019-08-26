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

class RegisterViewModel: ViewModelProtocol {
    var viewController: UIViewController?
    
    var bag = DisposeBag()
    
    var title: BehaviorRelay<String>
    
    var backgroundColor = BehaviorRelay<UIColor>.init(value: .white)
    
    var showHud: BehaviorRelay<NotifyMessage> = BehaviorRelay.init(value: .init(level: .hidden, type: .toast, content: ""))
    
    var isNavigationBarHidden = BehaviorRelay<Bool>.init(value: false)
    
    var leftNavigationItems: BehaviorRelay<[UIBarButtonItem]> = .init(value: [])
    var rightNavigationItems: BehaviorRelay<[UIBarButtonItem]> = .init(value: [])
    
    var viewDidLoad = PublishSubject<UIViewController>.init()

    var viewWillAppear = PublishSubject<Bool>()
    
    var viewDidAppear = PublishSubject<Bool>()
    
    var viewWillDisappear = PublishSubject<Bool>()
    
    var viewDidDisappear = PublishSubject<Bool>()
    
    init(title: String) {
        self.title = BehaviorRelay<String>.init(value: title)
    }
    
}
