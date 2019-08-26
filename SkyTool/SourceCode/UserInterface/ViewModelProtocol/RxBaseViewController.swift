//
//  RxBaseViewController.swift
//  SkyTool
//
//  Created by tree on 2019/8/4.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

class RxBaseViewController: UIViewController, ViewControllerViewModelType {

    var viewModel: ViewModelProtocol?
    
    init(viewModel: ViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        configure(viewModel: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidLoad.onNext(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewWillAppear.onNext(animated)
        guard let hidden = viewModel?.isNavigationBarHidden.value else { return }
        navigationController?.setNavigationBarHidden(hidden, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.viewDidAppear.onNext(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.viewWillDisappear.onNext(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel?.viewDidDisappear.onNext(animated)
    }
}
