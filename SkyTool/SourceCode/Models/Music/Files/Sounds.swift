//
//  Sounds.swift
//  MusicXML
//
//  Created by James Bean on 12/3/18.
//
//    MusicXML Sounds DTD
//
//    Version 3.1
//
//    Copyright © 2004-2017 the Contributors to the MusicXML
//    Specification, published by the W3C Music Notation Community
//    Group under the W3C Community Final Specification Agreement
//    (FSA):
//
//       https://www.w3.org/community/about/agreements/final/
//
//    A human-readable summary is available:
//
//       https://www.w3.org/community/about/agreements/fsa-deed/

//    Starting with Version 3.0, the MusicXML format includes a
//    standard set of instrument sounds to identify musical
//    timbres. These values are used in the instrument-sound
//    element.
//
//    The standard sounds are listed in the sounds.xml file
//    included with MusicXML 3.1. This is the document type
//    definition for that file.
//
//    Suggested use:
//
//    <!DOCTYPE sounds PUBLIC
//        "-//Recordare//DTD MusicXML 3.1 Sounds//EN"
//        "http://www.musicxml.org/dtds/sounds.dtd">

// MARK: Elements

// > Sounds is the document element.
//
// <!ELEMENT sounds (sound+)>
//
// > The sound element lists one of the standard sounds available
// > in MusicXML 3.0. The required id attribute lists the MusicXML
// > sound identifier string used by the instrument-sound element.
//
// > The optional any, solo, and ensemble elements can be used for
// > mapping MusicXML sound IDs to an application's or virtual
// > instrument library's method of identifying sounds. These
// > methods could include Sibelius SoundWorld IDs, capella
// > genericsound IDs, and General MIDI patch numbers.
//
// > The primary attribute is used to distinguish a primary choice
// > when multiple options are available in a single sounds.xml
// > file. The primary attribute for the sound element is used when
// > multiple sound elements map to the same application or library
// > ID. In this case, the primary attribute indicates which of the
// > MusicXML IDs is primary when mapping to a MusicXML sound id.
//
// > Multiple any, solo, and ensemble elements can be used when
// > multiple application sounds map to the same MusicXML sound id.
// > The primary attribute indicates which of the any, solo, or
// > ensemble elements is primary when mapping from a MusicXML
// > sound id.
//
// <!ELEMENT sound (any* | (solo*, ensemble*))>
// <!ATTLIST sound
//    id ID #REQUIRED
//    primary (yes | no) #IMPLIED
// >
public struct Sound: Codable, Equatable {

    // <!ELEMENT any (#PCDATA)>
    // <!ATTLIST any
    //    primary (yes | no) #IMPLIED
    // >

    // <!ELEMENT solo (#PCDATA)>
    // <!ATTLIST solo
    //    primary (yes | no) #IMPLIED
    // >
    public struct Solo: Codable, Equatable {
        let value: String
        let primary: Bool?
    }

    // <!ELEMENT ensemble (#PCDATA)>
    // <!ATTLIST ensemble
    //    number NMTOKEN #IMPLIED
    //    primary (yes | no) #IMPLIED
    // >
    public struct Ensemble: Codable, Equatable {
        let value: String

        // > The number attribute for
        // > the ensemble element represents the size of the ensemble,
        // > corresponding to the content of the ensemble element in a
        // > MusicXML score file.
        let number: Int?
        let primary: Bool?
    }

//    let id: String?
//    let primary: Bool?
//    
//    let solos: [Solo]?
//    let ensembles: [Ensemble]?
    let tempo: String?
}
