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

// 音符序列
function testClefNode(renderer, stave) {
  var context = renderer.getContext();
  var notes = [
    // A quarter-note C.
    new VF.StaveNote({ clef: "treble", keys: ["c/4"], duration: "q" }),

    // A quarter-note D.
    new VF.StaveNote({ clef: "treble", keys: ["d/4"], duration: "q" }),

    // A quarter-note rest. Note that the key (b/4) specifies the vertical
    // position of the rest.
    new VF.StaveNote({ clef: "treble", keys: ["b/4"], duration: "qr" }),

    // A C-Major chord.
    new VF.StaveNote({
      clef: "treble",
      keys: ["c/4", "e/4", "g/4"],
      duration: "q"
    })
  ];

  var notes2 = [
    new VF.StaveNote({ clef: "treble", keys: ["c/4"], duration: "w" })
  ];

  var voices = [
    new VF.Voice({ num_beats: 4, beat_value: 4 }).addTickables(notes),
    new VF.Voice({ num_beats: 4, beat_value: 4 }).addTickables(notes2)
  ];

  // Create a voice in 4/4 and add above notes
  var voice = new VF.Voice({ num_beats: 4, beat_value: 4 });
  voice.addTickables(notes);

  // Format and justify the notes to 400 pixels.
  var formatter = new VF.Formatter().joinVoices(voices).format(voices, 400);

  // Render voice
  voices.forEach(function(v) {
    v.draw(context, stave);
  });
}

// 延长符
function testNoteAccidentalsAndDots(renderer, stave) {
  var context = renderer.getContext();

  var notes = [
    new VF.StaveNote({ clef: "treble", keys: ["e##/5"], duration: "8d" })
      .addAccidental(0, new VF.Accidental("##"))
      .addDotToAll(),
    new VF.StaveNote({
      clef: "treble",
      keys: ["eb/5"],
      duration: "16"
    }).addAccidental(0, new VF.Accidental("b")),
    new VF.StaveNote({
      clef: "treble",
      keys: ["d/5", "eb/4"],
      duration: "h"
    }).addDot(0),
    new VF.StaveNote({
      clef: "treble",
      keys: ["c/5", "eb/5", "g#/5"],
      duration: "q"
    })
      .addAccidental(1, new VF.Accidental("b"))
      .addAccidental(2, new VF.Accidental("#"))
      .addDotToAll()
  ];
  VF.Formatter.FormatAndDraw(context, stave, notes);
}

// 单个音符
function testDrawSingleNote(renderer, stave, content) {
  var context = renderer.getContext();

  var notes = [
    new VF.StaveNote({ clef: "treble", keys: [content], duration: "h" })
  ];
  VF.Formatter.FormatAndDraw(context, stave, notes);
}

// 连线
function testBeamNotes(renderer, stave) {
  var context = renderer.getContext();
  var notes = [
    new VF.StaveNote({ clef: "treble", keys: ["e##/5"], duration: "8d" })
      .addAccidental(0, new VF.Accidental("##"))
      .addDotToAll(),
    new VF.StaveNote({
      clef: "treble",
      keys: ["b/4"],
      duration: "16"
    }).addAccidental(0, new VF.Accidental("b"))
  ];

  var notes2 = [
    new VF.StaveNote({ clef: "treble", keys: ["c/4"], duration: "8d" }),
    new VF.StaveNote({ clef: "treble", keys: ["d/4"], duration: "16" }),
    new VF.StaveNote({
      clef: "treble",
      keys: ["b/4"],
      duration: "16"
    }).addAccidental(0, new VF.Accidental("b"))
  ];

  var beams = [new VF.Beam(notes), new VF.Beam(notes2)];
  var all_notes = notes.concat(notes2);
  Vex.Flow.Formatter.FormatAndDraw(context, stave, all_notes);
  beams.forEach(function(b) {
    b.setContext(context).draw();
  });
}

// 连线
function testBeamNotes2(renderer, stave) {
  var context = renderer.getContext();
  var notes = [
    new VF.StaveNote({ clef: "treble", keys: ["e##/5"], duration: "8d" })
      .addAccidental(0, new VF.Accidental("##"))
      .addDotToAll(),
    new VF.StaveNote({
      clef: "treble",
      keys: ["b/4"],
      duration: "16"
    }).addAccidental(0, new VF.Accidental("b")),
    new VF.StaveNote({ clef: "treble", keys: ["c/4"], duration: "8" }),
    new VF.StaveNote({ clef: "treble", keys: ["d/4"], duration: "16" }),
    new VF.StaveNote({
      clef: "treble",
      keys: ["e/4"],
      duration: "16"
    }).addAccidental(0, new VF.Accidental("b")),
    new VF.StaveNote({ clef: "treble", keys: ["d/4"], duration: "16" }),
    new VF.StaveNote({
      clef: "treble",
      keys: ["e/4"],
      duration: "16"
    }).addAccidental(0, new VF.Accidental("#")),
    new VF.StaveNote({ clef: "treble", keys: ["g/4"], duration: "32" }),
    new VF.StaveNote({ clef: "treble", keys: ["a/4"], duration: "32" }),
    new VF.StaveNote({ clef: "treble", keys: ["g/4"], duration: "16" }),
    new VF.StaveNote({ clef: "treble", keys: ["d/4"], duration: "q" })
  ];

  var beams = VF.Beam.generateBeams(notes);
  Vex.Flow.Formatter.FormatAndDraw(context, stave, notes);
  beams.forEach(function(b) {
    b.setContext(context).draw();
  });
}

// 连线
function testTies(renderer, stave) {
  var context = renderer.getContext();
  var notes = [
    new VF.StaveNote({ clef: "treble", keys: ["e##/5"], duration: "8d" })
      .addAccidental(0, new VF.Accidental("##"))
      .addDotToAll(),
    new VF.StaveNote({
      clef: "treble",
      keys: ["b/4"],
      duration: "16"
    }).addAccidental(0, new VF.Accidental("b")),
    new VF.StaveNote({ clef: "treble", keys: ["c/4"], duration: "8" }),
    new VF.StaveNote({ clef: "treble", keys: ["d/4"], duration: "16" }),
    new VF.StaveNote({ clef: "treble", keys: ["d/4"], duration: "16" }),
    new VF.StaveNote({ clef: "treble", keys: ["d/4"], duration: "q" }),
    new VF.StaveNote({ clef: "treble", keys: ["d/4"], duration: "q" })
  ];

  var beams = VF.Beam.generateBeams(notes);
  VF.Formatter.FormatAndDraw(context, stave, notes);
  beams.forEach(function(b) {
    b.setContext(context).draw();
  });

  var ties = [
    new VF.StaveTie({
      first_note: notes[4],
      last_note: notes[5],
      first_indices: [0],
      last_indices: [0]
    }),
    new VF.StaveTie({
      first_note: notes[5],
      last_note: notes[6],
      first_indices: [0],
      last_indices: [0]
    })
  ];

  ties.forEach(function(t) {
    t.setContext(context).draw();
  });
}

function testGuitarTablature(renderer) {
  var context = renderer.getContext();
  // Create a tab stave of width 400 at position 10, 40 on the canvas.
  var stave = new VF.TabStave(10, 40, 400);
  stave
    .addClef("tab")
    .setContext(context)
    .draw();

  var notes = [
    // A single note
    new VF.TabNote({
      positions: [{ str: 3, fret: 7 }],
      duration: "q"
    }),

    // A chord with the note on the 3rd string bent
    new VF.TabNote({
      positions: [{ str: 2, fret: 10 }, { str: 3, fret: 9 }],
      duration: "q"
    }).addModifier(new VF.Bend("Full"), 1),

    // A single note with a harsh vibrato
    new VF.TabNote({
      positions: [{ str: 2, fret: 5 }],
      duration: "h"
    }).addModifier(new VF.Vibrato().setHarsh(true).setVibratoWidth(70), 0)
  ];

  VF.Formatter.FormatAndDraw(context, stave, notes);
}

function testEasyScore() {
  var vf = new Vex.Flow.Factory({ renderer: { elementId: "boo" } });
  var score = vf.EasyScore();
  var system = vf.System();
  system
    .addStave({
      voices: [
        score.voice(score.notes("C#5/q, B4, A4, G#4")),
        score.voice(score.notes("C#4/h, C#4", { stem: "down" }))
      ]
    })
    .addClef("treble")
    .addTimeSignature("4/4");

  system
    .addStave({
      voices: [
        score.voice(
          score.notes("C#3/q, B2, A2/8, B2, C#3, D3", {
            clef: "bass",
            stem: "up"
          })
        ),
        score.voice(score.notes("C#2/h, C#2", { clef: "bass", stem: "down" }))
      ]
    })
    .addClef("treble")
    .addTimeSignature("4/4");
  vf.draw();
}
