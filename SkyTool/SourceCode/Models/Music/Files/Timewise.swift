//
//  Timewise.swift
//  MusicXML
//
//  Created by James Bean on 12/3/18.
//
//  MusicXML Timewise DTD
//
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

//extension MusicXML {
//    // MARK: TODO
//    public struct Timewise: Equatable { }
//}

// MARK: TODO
//
//<!--
//    The MusicXML format is designed to represent musical scores,
//    specifically common western musical notation from the 17th
//    century onwards. It is designed as an interchange format
//    for notation, analysis, retrieval, and performance
//    applications. Therefore it is intended to be sufficient,
//    not optimal, for these applications.
//
//    The MusicXML format is based on the MuseData and Humdrum
//    formats. Humdrum explicitly represents the two-dimensional
//    nature of musical scores by a 2-D layout notation. Since the
//    XML format is hierarchical, we cannot do this explicitly.
//    Instead, there are two top-level formats:
//
//    partwise.dtd   Represents scores by part/instrument
//    timewise.dtd   Represents scores by time/measure
//
//    Thus partwise.dtd contains measures within each part,
//    while timewise.dtd contains parts within each measure.
//    XSLT stylesheets are provided to convert between the
//    two formats.
//
//    The partwise and timewise score DTDs represent a single
//    movement of music. Multiple movements or other musical
//    collections are presented using opus.dtd. An opus
//    document contains XLinks to individual scores.
//
//    Suggested use:
//
//    <!DOCTYPE score-timewise PUBLIC
//        "-//Recordare//DTD MusicXML 3.1 Timewise//EN"
//        "http://www.musicxml.org/dtds/timewise.dtd">
//
//    This DTD is made up of a series of component DTD modules,
//    all of which are included here.
//-->
//
//<!-- Entities -->
//
//<!--
//    The partwise and timewise entities are used with
//    conditional sections to control the differences between
//    the partwise and timewise DTDs. The values for these
//    entities are what distinguish the partwise and timewise
//    DTD files.
//-->
//<!ENTITY % partwise "IGNORE">
//<!ENTITY % timewise "INCLUDE">
//
//<!-- Component DTD modules -->
//
//<!--
//    The common DTD module contains the entities and elements
//    that are shared among multiple component DTDs.
//-->
//<!ENTITY % common PUBLIC
//    "-//Recordare//ELEMENTS MusicXML 3.1 Common//EN"
//    "common.mod">
//%common;
//
//<!--
//    The layout DTD module contains formatting information for
//    pages, systems, staves, and measures.
//-->
//<!ENTITY % layout PUBLIC
//    "-//Recordare//ELEMENTS MusicXML 3.1 Layout//EN"
//    "layout.mod">
//%layout;
//
//<!--
//    The identity DTD module contains identification and
//    metadata elements.
//-->
//<!ENTITY % identity PUBLIC
//    "-//Recordare//ELEMENTS MusicXML 3.1 Identity//EN"
//    "identity.mod">
//%identity;
//
//<!--
//    The attributes DTD module contains elements that usually
//    change at the start of a measure, such as key signatures,
//    time signatures, and clefs.
//-->
//<!ENTITY % attributes PUBLIC
//    "-//Recordare//ELEMENTS MusicXML 3.1 Attributes//EN"
//    "attributes.mod">
//%attributes;
//
//<!--
//    The link DTD module contains XLink attributes.
//-->
//<!ENTITY % link PUBLIC
//    "-//Recordare//ELEMENTS MusicXML 3.1 Link//EN"
//    "link.mod">
//%link;
//
//<!--
//    The note DTD module contains the bulk of the elements
//    and attributes for a musical scores relating to individual
//    notes and rests.
// -->
//<!ENTITY % note PUBLIC
//    "-//Recordare//ELEMENTS MusicXML 3.1 Note//EN"
//    "note.mod">
//%note;
//
//<!--
//    The barline DTD module contains elements regarding
//    barline style, repeats, and multiple endings.
//-->
//<!ENTITY % barline PUBLIC
//    "-//Recordare//ELEMENTS MusicXML 3.1 Barline//EN"
//    "barline.mod">
//%barline;
//
//<!--
//    The direction DTD module contains elements for musical
//    directions not tied to individual notes. This includes
//    harmony and chord symbol elements.
//-->
//<!ENTITY % direction PUBLIC
//    "-//Recordare//ELEMENTS MusicXML 3.1 Direction//EN"
//    "direction.mod">
//%direction;
//
//<!--
//    The score DTD module contains the top-level elements for
//    musical scores, including the root document elements.
//-->
//<!ENTITY % score PUBLIC
//    "-//Recordare//ELEMENTS MusicXML 3.1 Score//EN"
//    "score.mod">
//%score;
