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

public protocol DisposeProtocol {
    var bag: DisposeBag { get }
}

public protocol ViewModelProtocol: DisposeProtocol {
    
    var viewController: UIViewController? { get set }
    
    /// 标题
    var title: BehaviorRelay<String> { get }
    
    /// 背景色
    var backgroundColor: BehaviorRelay<UIColor> { get }
    
    /// HUD 选项
    var showHud: BehaviorRelay<NotifyMessage> { get }
    
    /// 是否显示导航
    var isNavigationBarHidden: BehaviorRelay<Bool> { get }
    
    var leftNavigationItems: BehaviorRelay<[UIBarButtonItem]> { get set }
    var rightNavigationItems: BehaviorRelay<[UIBarButtonItem]> { get set }
    
    /// 声明周期
    var viewDidLoad: PublishSubject<UIViewController> { get }
    var viewWillAppear: PublishSubject<Bool> { get }
    var viewDidAppear: PublishSubject<Bool> { get }
    var viewWillDisappear: PublishSubject<Bool> { get }
    var viewDidDisappear: PublishSubject<Bool> { get }
    
}

protocol ViewControllerViewModelType where Self: UIViewController {
    var viewModel: ViewModelProtocol? { get set }
    
    func configure(viewModel: ViewModelProtocol)
}

extension ViewControllerViewModelType {
    
    func configure(viewModel: ViewModelProtocol) {
        self.viewModel = viewModel
        viewModel.backgroundColor
            .bind(to: view.rx.backgroundColor)
            .disposed(by: viewModel.bag)
        
        viewModel.title
            .bind(to: rx.title)
            .disposed(by: viewModel.bag)
        
        viewModel.showHud.subscribe({ (event) in
            guard let message = event.element else { return }
            SessionManager.shared.notify(message: message)
        }).disposed(by: viewModel.bag)
        
    }
    
}

protocol ListViewModelProtocol: UITableViewDelegate, UITableViewDataSource {}
