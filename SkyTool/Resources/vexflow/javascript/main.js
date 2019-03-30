var CONSTANT = {
  elementWidth: {
    "w": 100, 
    "h": 80, 
    "q": 60, 
    "8": 50, 
    "16": 40, 
    "32": 40
  }
}

var VexTranslator = function(dom) {
  var VF = Vex.Flow;
  var renderer = new VF.Renderer(dom, VF.Renderer.Backends.SVG);

  var obj = {
    vf: VF,
    renderer: renderer,
    dom: dom,
    notes: [],
    staves: [],
  };

  obj.setClef = function(clef, signature) {
    var context = this.renderer.getContext();
    var stave = new VF.Stave(10, 40, this.dom.clientWidth - 40);
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
    var note = new VF.StaveNote({
      clef: clef,
      keys: keys,
      duration: duration
    });
    return note;
  };

  obj.createVoice = function(notes) {
    var voice = new Vex.Flow.Voice({
      num_beats: 4,
      beat_value: 4
    });
    voice.addTickables(notes);
    this.notes.push(notes);
    this.createStave(voice);
    return voice
  }

  obj.createStave = function(voice) {
    var stave = new Vex.Flow.Stave(60, 40, 200);
    stave.voice = voice;
    voice.bar = stave;
    this.staves.push(stave);
  }

  obj.render = function() {
    var context = this.renderer.getContext();
    for (let index = 0; index < this.staves.length; index++) {
      const stave = this.staves[index];
      const notes = this.notes[index];
      VF.Formatter.FormatAndDraw(context, stave, notes);
    }
  };

  return obj;
};
