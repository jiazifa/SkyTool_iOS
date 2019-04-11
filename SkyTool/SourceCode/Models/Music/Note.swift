//
//  Note.swift
//  SkyTool
//
//  Created by tree on 2019/4/11.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation

public struct Note {
    public enum Letter: String {
        case C = "C"
        case CSharp = "C#"
        case D = "D"
        case DSharp = "D#"
        case E = "E"
        case F = "F"
        case FSharp = "F#"
        case G = "G"
        case GSharp = "G#"
        case A = "A"
        case ASharp = "A#"
        case B = "B"
        
        public static var values: [Note.Letter] = [
            .C, .CSharp, .D, .DSharp, .E, .F, .FSharp, .G, .GSharp, .A, .ASharp, .B
        ]
    }
    
    public let letter: Letter
    public let octave: Int // 八度
    
    public init(letter: Letter, octave: Int) {
        self.letter = letter
        self.octave = octave
    }
}

extension Note: CustomStringConvertible {
    public var description: String {
        return "\(self.letter.rawValue.lowercased())/\(self.octave)"
    }
}

public struct StaveNote {
    public let notes: [Note]
    public let isDot: Bool
    public let duration: Duration
    
    init(notes: [Note], isDot: Bool, duration: Duration) {
        self.notes = notes
        self.isDot = isDot
        self.duration = duration
    }
}

extension StaveNote: CustomStringConvertible {
    public var description: String {
        return "\(self.notes)"
    }
}
