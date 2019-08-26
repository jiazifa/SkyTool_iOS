//
//  ViewControllerCooridinatorType.swift
//  SkyTool
//
//  Created by tree on 2019/8/16.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

protocol ViewControllerCooridinatorType: class {
    func pushViewController(from sourceViewController: UIViewController, to targetViewController: UIViewController, animated: Bool)
    
    func popViewController(from sourceViewController: UIViewController, animated: Bool)
    
    func popToRootViewController(from sourceViewController: UIViewController, animated: Bool)
    
    func popToRootViewControllerAndPush(from sourceViewController: UIViewController, to targetViewController: UIViewController, popAnimated: Bool, pushAnimated: Bool)
    
    func present(from sourceViewController: UIViewController, target: UIViewController, animated: Bool, completion: (() -> Void)?)

    func dismiss(from sourceViewController: UIViewController, animated: Bool, completion: (() -> Void)?)
}

extension ViewControllerCooridinatorType {
    func pushViewController(from sourceViewController: UIViewController, to targetViewController: UIViewController, animated: Bool=true) {
        guard let navigation = sourceViewController.navigationController else {
            present(from: sourceViewController, target: targetViewController, animated: animated, completion: nil)
            return
        }
        navigation.pushViewController(targetViewController, animated: animated)
    }
    
    func popViewController(from sourceViewController: UIViewController, animated: Bool) {
        guard let navigation = sourceViewController.navigationController else { return }
        navigation.popViewController(animated: animated)
    }
    
    func popToRootViewController(from sourceViewController: UIViewController, animated: Bool) {
        guard let navigation = sourceViewController.navigationController else { return }
        navigation.popToRootViewController(animated: animated)
    }
    
    func popToRootViewControllerAndPush(from sourceViewController: UIViewController, to targetViewController: UIViewController, popAnimated: Bool, pushAnimated: Bool) {
        guard let navigation = sourceViewController.navigationController else {
            present(from: sourceViewController, target: targetViewController, animated: pushAnimated, completion: nil)
            return
        }
        navigation.popToRootViewController(animated: popAnimated)
        navigation.pushViewController(targetViewController, animated: pushAnimated)
    }
    
    func present(from sourceViewController: UIViewController, target: UIViewController, animated: Bool, completion: (() -> Void)?) {
        sourceViewController.present(target, animated: animated, completion: completion)
    }
    
    func dismiss(from sourceViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        sourceViewController.dismiss(animated: animated, completion: completion)
    }
    
}
