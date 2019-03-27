//
//  Group.swift
//  MusicXML
//
//  Created by James Bean on 12/21/18.
//

// > The group element allows the use of different versions of
// > the part for different purposes. Typical values include
// > score, parts, sound, and data. Ordering information that is
// > directly encoded in MuseData can be derived from the
// > ordering within a MusicXML score or opus.
//
// <!ELEMENT group (#PCDATA)>
public struct Group {
    let value: String
}

// > The part-group element indicates groupings of parts in the
// > score, usually indicated by braces and brackets. Braces
// > that are used for multi-staff parts should be defined in
// > the attributes element for that part. The part-group start
// > element appears before the first score-part in the group.
// > The part-group stop element appears after the last
// > score-part in the group.
//
// > The number attribute is used to distinguish overlapping
// > and nested part-groups, not the sequence of groups. As
// > with parts, groups can have a name and abbreviation.
// > Formatting attributes for group-name and group-abbreviation
// > are deprecated in Version 2.0 in favor of the new
// > group-name-display and group-abbreviation-display elements.
// > Formatting specified in the group-name-display and
// > group-abbreviation-display elements overrides formatting
// > specified in the group-name and group-abbreviation
// > elements, respectively.
// > The group-time element indicates that the
// > displayed time signatures should stretch across all parts
// > and staves in the group. Values for the child elements
// > are ignored at the stop of a group.
// > A part-group element is not needed for a single multi-staff
// > part. By default, multi-staff parts include a brace symbol
// > and (if appropriate given the bar-style) common barlines.
// > The symbol formatting for a multi-staff part can be more
// > fully specified using the part-symbol element, defined in
// > the attributes.mod file.
//
// <!ELEMENT part-group (group-name?, group-name-display?,
//    group-abbreviation?, group-abbreviation-display?,
//    group-symbol?, group-barline?, group-time?, %editorial;)>
// <!ATTLIST part-group
//    type %start-stop; #REQUIRED
//    number CDATA "1"
// >
public struct PartGroup: Codable, Equatable {
    let type: StartStop
    let number: String?
    let name: GroupName?
    let abbreviation: GroupAbbreviation?
    let symbol: GroupSymbol?
    let barline: GroupBarline?
    // <!ELEMENT group-time EMPTY>
    let time: Bool?
    let editorial: Editorial?
}

// <!ELEMENT group-name (#PCDATA)>
// <!ATTLIST group-name
//    %print-style;
//    %justify;
// >
public struct GroupName: Codable, Equatable {
    let value: String
    let printStyle: PrintStyle?
    let justification: Justification?
}

// <!ELEMENT group-name-display
//    ((display-text | accidental-text)*)>
// <!ATTLIST group-name-display
//    %print-object;
// >

// <!ELEMENT group-abbreviation (#PCDATA)>
// <!ATTLIST group-abbreviation
//    %print-style;
//    %justify;
// >
public struct GroupAbbreviation: Codable, Equatable {
    let value: String
    let printStyle: PrintStyle?
    let justification: Justification?
}

// <!ELEMENT group-abbreviation-display
//    ((display-text | accidental-text)*)>
// <!ATTLIST group-abbreviation-display
//    %print-object;
// >

// > The group-symbol element indicates how the symbol for
// > a group is indicated in the score. Values include none,
// > brace, line, bracket, and square; the default is none.
//
// <!ELEMENT group-symbol (#PCDATA)>
// <!ATTLIST group-symbol
//    %position;
//    %color;
// >
public struct GroupSymbol: Codable, Equatable {
    public enum Value: String, Codable {
        case none
        case brace
        case line
        case bracket
        case square
    }
    let value: Value
    let position: Position?
    let color: Color?
}

// > The group-barline element indicates if the group should
// > have common barlines. Values can be yes, no, or
// > Mensurstrich.
//
// <!ELEMENT group-barline (#PCDATA)>
// <!ATTLIST group-barline
//    %color;
// >
public struct GroupBarline: Codable, Equatable {
    public enum Value: String, Codable {
        case yes
        case no
        case mensurstrich = "Mensurstrich"
    }
    let value: Value
    let color: Color?
}
