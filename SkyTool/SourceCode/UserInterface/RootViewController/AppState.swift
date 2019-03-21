//
//  AppState.swift
//  HuBeiECarSalerClient
//
//  Created by tree on 2018/12/21.
//  Copyright © 2018 tree. All rights reserved.
//

import Foundation

enum AppState: Equatable {
    case headless // 启动页
    case unauthenticated // 未登录状态
    case authenticated(account: Account) // 主页
}
