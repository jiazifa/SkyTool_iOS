//
//  Part.swift
//  SkyTool
//
//  Created by tree on 2019/3/27.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

// part
public struct Part: Codable, Equatable {
    let measure: [Measure]?
}

public struct Measure: Codable, Equatable {
//    let print: Print?
//    let attributes: String?
//    let sound: Sound?
//    let direction: Direction?
//    let note: Note?
    let number: String?
    let width: String?
}
