//
//  RxBaseViewController.swift
//  SkyTool
//
//  Created by tree on 2019/8/4.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

class RxBaseViewController: UIViewController {

    var viewModel: ViewControllerViewModelProtocol
    
    init(viewModel: ViewControllerViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad.onNext(self)
        createReact()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear.onNext(animated)
        let hidden = viewModel.isNavigationBarHidden.value
        navigationController?.setNavigationBarHidden(hidden, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear.onNext(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear.onNext(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear.onNext(animated)
    }
    
    func createReact() {
        viewModel.title
            .bind(to: rx.title)
            .disposed(by: viewModel.bag)
        
        viewModel.backgroundColor
            .bind(to: view.rx.backgroundColor)
            .disposed(by: viewModel.bag)
        
        viewModel.showHud.subscribe { [weak self] (event) in
            guard let this = self else { return }
            let action = event.element ?? .none
            switch action {
            case .none:
                this.stopIndicator()
            case .indicator(_):
                this.startIndicator()
            case .toast(_): break
            }
        }.disposed(by: viewModel.bag)
        
        
    }
}
