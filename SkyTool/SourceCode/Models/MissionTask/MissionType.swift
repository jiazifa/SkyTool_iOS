//
//  MissionType.swift
//  SkyTool
//
//  Created by tree on 2019/4/11.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import UIKit

public enum MissionType {
    case none
    case record
    case internalWeb
    case externalWeb
    case viewController(_ target: UIViewController)
}

public protocol MissionTaskType: CommandType {
    var type: MissionType { get }
    
    var name: String { get set }
    
    var viewController: UIViewController? { get set }
}
