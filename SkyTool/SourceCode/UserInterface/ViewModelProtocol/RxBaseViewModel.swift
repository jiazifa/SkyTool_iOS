//
//  RxBaseViewModel.swift
//  SkyTool
//
//  Created by tree on 2019/8/17.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RxBaseViewModel: NSObject, ViewModelProtocol {
    var viewController: UIViewController?
    
    var title: BehaviorRelay<String> = BehaviorRelay.init(value: "")
    
    var backgroundColor: BehaviorRelay<UIColor> = .init(value: UIColor.contentBackground)
    
    var showHud: BehaviorRelay<NotifyMessage> = .init(value: .none())
    
    var isNavigationBarHidden: BehaviorRelay<Bool> = .init(value: false)
    
    var leftNavigationItems: BehaviorRelay<[UIBarButtonItem]> = .init(value: [])
    var rightNavigationItems: BehaviorRelay<[UIBarButtonItem]> = .init(value: [])
    
    var viewDidLoad: PublishSubject<UIViewController> = .init()
    
    var viewWillAppear: PublishSubject<Bool> = .init()
    
    var viewDidAppear: PublishSubject<Bool> = .init()
    
    var viewWillDisappear: PublishSubject<Bool> = .init()
    
    var viewDidDisappear: PublishSubject<Bool> = .init()
    
    var bag: DisposeBag = DisposeBag.init()
    
}
