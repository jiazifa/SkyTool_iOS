//
//  SkyNoteTest.swift
//  SkyToolTests
//
//  Created by tree on 2019/4/11.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation
import XCTest
@testable import SkyTool

class SkyNoteTests: XCTestCase {
    
    override func setUp() {
    }
    
    func testNote() {
        let note = Note.init(letter: .C, octave: 1)
        XCTAssertEqual(note.letter, Note.Letter.C)
    }
    
    override func tearDown() {
        super.tearDown()
    }
}
