var CONSTANT = {
  elementWidth: {
    w: 100,
    h: 80,
    q: 60,
    "8": 50,
    "16": 40,
    "32": 40
  }
};

var VexFactory = function() {
  var VF = Vex.Flow;
  var obj = {
    vf: VF
  };

  obj.createNote = function(clef, keys, duration) {
    var note = new this.vf.StaveNote({
      clef: clef,
      keys: keys,
      duration: duration
    });
    return note;
  };

  obj.createVoice = function(num_beats, beat_value) {
    var voice = new Vex.Flow.Voice({
      num_beats: num_beats,
      beat_value: beat_value
    });
    return voice;
  };

  obj.createStave = function(offX, offY, width) {
    var stave = new Vex.Flow.Stave(offX, offY, width);
    return stave;
  };

  obj.bindVoiceToStave = function(voice, stave) {
    voice.bar = stave;
    stave.voice = voice;
  };
  obj.bindNoteToVoice = function(notes, voice) {
    voice.addTickables(notes);
  };

  return obj;
};

var VexTranslator = function(dom) {
  var VF = Vex.Flow;
  var renderer = new VF.Renderer(dom, VF.Renderer.Backends.SVG);
  var factory = new VexFactory();
  var obj = {
    vf: VF,
    renderer: renderer,
    dom: dom,
    notes: [],
    staves: [],
    factory: factory
  };

  obj.setClef = function(clef, signature) {
    var context = this.renderer.getContext();
    if (this.staves.length === 0) { return; }
    var stave = this.staves[this.staves.length - 1];

    if (clef) {
      stave.addClef(clef);
    }
    if (signature) {
      stave.addTimeSignature(signature);
    }
    stave.setContext(context).draw();
    this.stave = stave;
  };

  obj.createNote = function(clef, keys, duration) {
    var note = this.factory.createNote(clef, keys, duration);
    var params = {
      note: note,
      width: CONSTANT.elementWidth[duration]
    };
    return params;
  };

  obj.createVoice = function(notes) {
    var voice = new Vex.Flow.Voice({
      num_beats: 4,
      beat_value: 4,
      resolution: Vex.Flow.RESOLUTION,
    });
    var newNotes = [];
    var voiceWidth = 0;
    if (this.staves.length === 0) {
      voiceWidth += 60;
    }
    
    notes.forEach(function(params) {
      newNotes.push(params.note);
      voiceWidth += params.width;
    });
    voice.addTickables(newNotes);
    voice.barWidth = voiceWidth;
    this.notes.push(notes);
    this.createStave(voice, voiceWidth);
    return voice;
  };

  obj.createStave = function(voice, width) {
    var stave = this.factory.createStave(0, 0, width);
    this.factory.bindVoiceToStave(voice, stave);
    this.staves.push(stave);
    var context = this.renderer.getContext();
    stave.setContext(context).draw();
  };

  obj.render = function() {
    var context = this.renderer.getContext();
    for (let index = 0; index < this.notes.length; index++) {
      const notes = this.notes[index];
      const stave = this.staves[index];
      var drawNotes = notes.map(function(p) {
        return p.note;
      });
      var drawWidth = 60;
      notes.forEach(function(p) {
        drawWidth += p.width;
      });
      VF.Formatter.FormatAndDraw(context, stave, drawNotes);
    }
  };

  return obj;
};
