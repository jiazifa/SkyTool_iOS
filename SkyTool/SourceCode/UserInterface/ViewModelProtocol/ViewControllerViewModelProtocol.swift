//
//  ViewControllerViewModelProtocol.swift
//  SkyTool
//
//  Created by tree on 2019/8/4.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol DisposeProtocol {
    var bag: DisposeBag { get }
}

enum HUDType {
    case toast(String)
    case indicator(String?)
    case none
}

protocol ViewControllerViewModelProtocol: DisposeProtocol {
    
    /// 标题
    var title: BehaviorRelay<String> { get }
    
    /// 背景色
    var backgroundColor: BehaviorRelay<UIColor> { get }
    
    /// HUD 选项
    var showHud: BehaviorRelay<HUDType> { get }
    
    /// 是否显示导航
    var isNavigationBarHidden: BehaviorRelay<Bool> { get }
    
    /// 声明周期
    var viewDidLoad: PublishSubject<UIViewController> { get }
    var viewWillAppear: PublishSubject<Bool> { get }
    var viewDidAppear: PublishSubject<Bool> { get }
    var viewWillDisappear: PublishSubject<Bool> { get }
    var viewDidDisappear: PublishSubject<Bool> { get }
}

protocol ViewControllerViewModelType {
    var viewModel: ViewControllerViewModelProtocol { get }
    
    init(viewModel: ViewControllerViewModelProtocol)
    
    func configureViewModel()
}

protocol ListViewModelProtocol {
    
}
