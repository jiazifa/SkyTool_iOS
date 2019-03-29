function testRenderContext(dom) {
  VF = Vex.Flow;
  // Create an SVG renderer and attach it to the DIV element named "boo".
  var div = dom;
  var renderer = new VF.Renderer(div, VF.Renderer.Backends.SVG);
  return renderer;
}

function testClef(renderer) {
  // Size our svg:
  renderer.resize(700, 400);

  // And get a drawing context:
  var context = renderer.getContext();

  // Create a stave at position 10, 40 of width 400 on the canvas.
  var stave = new VF.Stave(10, 40, 400); // 创建一行

  // Add a clef and time signature.
  stave.addClef("treble").addTimeSignature("4/4");

  // Connect it to the rendering context and draw!
  stave.setContext(context).draw();
  return stave;
}

function testClefNode(renderer, stave) {
  var context = renderer.getContext();
  var notes = [
    // A quarter-note C.
    new VF.StaveNote({clef: "treble", keys: ["c/4"], duration: "q" }),
  
    // A quarter-note D.
    new VF.StaveNote({clef: "treble", keys: ["d/4"], duration: "q" }),
  
    // A quarter-note rest. Note that the key (b/4) specifies the vertical
    // position of the rest.
    new VF.StaveNote({clef: "treble", keys: ["b/4"], duration: "qr" }),
  
    // A C-Major chord.
    new VF.StaveNote({clef: "treble", keys: ["c/4", "e/4", "g/4"], duration: "q" })
  ];

  var notes2 = [
    new VF.StaveNote({clef: "treble", keys: ["c/4"], duration: "w" })
  ];

  var voices = [
    new VF.Voice({num_beats: 4,  beat_value: 4}).addTickables(notes),
	  new VF.Voice({num_beats: 4,  beat_value: 4}).addTickables(notes2)
  ]
  
  // Create a voice in 4/4 and add above notes
  var voice = new VF.Voice({num_beats: 4,  beat_value: 4});
  voice.addTickables(notes);
  
  // Format and justify the notes to 400 pixels.
  var formatter = new VF.Formatter().joinVoices(voices).format(voices, 400);
  
  // Render voice
  voices.forEach(function(v) {
    v.draw(context, stave);
  })
}

function testNoteAccidentalsAndDots(renderer, stave) {
  var context = renderer.getContext();

  var notes = [
    new VF.StaveNote({clef: "treble", keys: ["e##/5"], duration: "8d"}).addAccidental(0, new VF.Accidental("##")).addDotToAll(),
    new VF.StaveNote({clef: "treble", keys: ["eb/5"], duration: "16"}).addAccidental(0, new VF.Accidental("b")),
    new VF.StaveNote({clef: "treble", keys: ["d/5", "eb/4"], duration: "h"}).addDot(0),
    new VF.StaveNote({clef: "treble", keys: ["c/5", "eb/5", "g#/5"], duration: "q"}).addAccidental(1, new VF.Accidental("b")).addAccidental(2, new VF.Accidental("#")).addDotToAll(),
  ]
  VF.Formatter.FormatAndDraw(context, stave, notes);
}

function testDrawSingleNote(renderer, stave, content) {
  var context = renderer.getContext();

  var notes =  [
    new VF.StaveNote({clef: "treble", keys: [content], duration: "h"})
  ]
  VF.Formatter.FormatAndDraw(context, stave, notes);
}