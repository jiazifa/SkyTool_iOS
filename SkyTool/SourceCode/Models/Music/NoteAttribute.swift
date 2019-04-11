//
//  Clef.swift
//  SkyTool
//
//  Created by tree on 2019/3/29.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

public enum Clef: String {
    // G high
    case frenchViolin = "french-violin" // 上高音谱号/古法国式高音谱号
    case treble = "treble" // 高音谱号 ✨
    
    // C middle C
    case soprano = "soprano" // 女高音谱号
    case mezzoSoprano = "mezzo-soprano" //  女次高音谱号
    case alto = "alto" //     中音谱号 ✨
    case tenor = "tenor" // 次中音谱号 ✨
    case baritoneC = "baritone-c" // 上低音谱号 (中音谱号式)
    
    // F low
    case baritoneF = "baritone-f" // 上低音谱号 (低音谱号式)
    case bass = "bass" // 低音谱号 ✨
    case subbass = "subbass" // 倍低音谱号
    
    // tab
    case tab = "tab"
}

public enum Duration: String {
    case whole
    case half
    case quater
    case eighth
    case sixteenth
    case thirtyTwo
    case sixtyFour
    
    public var vexflowDescription: String {
        switch self {
        case .whole: return "w"
        case .half: return "h"
        case .quater: return "q"
        case .eighth: return "8"
        case .sixteenth: return "16"
        case .thirtyTwo: return "32"
        case .sixtyFour: return "64"
        }
    }
}
