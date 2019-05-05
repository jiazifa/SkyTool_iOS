//
//  MissionCoordinator.swift
//  SkyTool
//
//  Created by tree on 2019/4/24.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation

class MissionCoordinator {
    lazy var exisitsTypes: [MissionType] = {
        return TaskStore.shared.load().map({$0.type})
    }()
    
    func addMission(_ missionType: MissionType) {
        guard self.exisitsTypes.contains(missionType) == false else {
            return
        }
        switch missionType {
        case .rss:
            let mis = MissionBaseTask.init(name: "Rss", type: .rss)
            TaskStore.shared.add(mis)
            self.exisitsTypes = TaskStore.shared.load().map({$0.type})
        default: break
        }
    }
}
