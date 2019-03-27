//
//  Score.swift
//  MusicXML
//
//  Created by James Bean on 12/3/18.
//
//  MusicXML score.mod module
//  Version 3.1
//
//  Copyright © 2004-2017 the Contributors to the MusicXML
//  Specification, published by the W3C Music Notation Community
//  Group under the W3C Community Final Specification Agreement
//  (FSA):
//
//     https://www.w3.org/community/about/agreements/final/
//
//  A human-readable summary is available:
//
//     https://www.w3.org/community/about/agreements/fsa-deed/
//
// <!ENTITY % score-header
// "(work?, movement-number?, movement-title?,
// identification?, defaults?, credit*, part-list)">
import Foundation

public struct Score: Codable, Equatable {
    let work: Work?
    let movementNumber: String?
    let movementTitle: String?
    let identification: Identification?
    let defaults: Defaults?
    let partList: PartList
    let part: [Part]?
    
    enum CodingKeys: String, CodingKey {
        case work
        case movementNumber = "movement-number"
        case movementTitle = "movement-title"
        case partList = "part-list"
        case identification
        case defaults
        case part
    }
}

// <!ELEMENT work (work-number?, work-title?, opus?)>
// <!ELEMENT work-number (#PCDATA)>
// <!ELEMENT work-title (#PCDATA)>
public struct Work: Codable, Equatable {
    let number: String?
    let title: String?
    let opus: Opus?
}

// <!ELEMENT opus EMPTY>
// <!ATTLIST opus
//    %link-attributes;
// >
#warning("TODO: Implement Opus (LinkAttributes)")
public struct Opus: Codable, Equatable {
//    let linkAttributes: LinkAttributes
}

// > Collect score-wide defaults. This includes scaling
// > and layout, defined in layout.mod, and default values
// > for the music font, word font, lyric font, and
// > lyric language. The number and name attributes in
// > lyric-font and lyric-language elements are typically
// > used when lyrics are provided in multiple languages.
// > If the number and name attributes are omitted, the
// > lyric-font and lyric-language values apply to all
// > numbers and names.
//
// <!ELEMENT defaults (scaling?, page-layout?,
//    system-layout?, staff-layout*, appearance?,
//    music-font?, word-font?, lyric-font*, lyric-language*)>
public struct Defaults: Codable, Equatable {
    let scaling: Scaling?
    let pageLayout: PageLayout?
    let systemLayout: SystemLayout? // TODO: SystemLayout
    let appearance: Appearance? // TODO: Appearance

    // <!ELEMENT music-font EMPTY>
    // <!ATTLIST music-font
    //    %font;
    // >
    let musicFont: Font?

    // <!ELEMENT word-font EMPTY>
    // <!ATTLIST word-font
    //    %font;
    // >
    let wordFont: Font?
    let lyricFonts: [LyricFont]?
    let lyricLanguages: [LyricLanguage]?
}

// <!ELEMENT lyric-font EMPTY>
// <!ATTLIST lyric-font
//    number NMTOKEN #IMPLIED
//    name CDATA #IMPLIED
//    %font;
// >
public struct LyricFont: Codable, Equatable {
    let number: String?
    let name: String?
    let font: Font
}

// <!ELEMENT lyric-language EMPTY>
// <!ATTLIST lyric-language
//    number NMTOKEN #IMPLIED
//    name CDATA #IMPLIED
//    xml:lang NMTOKEN #REQUIRED
// >
//
public struct LyricLanguage: Codable, Equatable {
    let number: String?
    let name: String?
    let language: String
}
