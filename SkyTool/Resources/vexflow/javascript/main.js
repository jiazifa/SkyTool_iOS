var Util = {
  getClientWidth: function() {
    return document.body.clientWidth;
  },

  getClientHeight: function() {
    return document.body.clientHeight;
  }
};

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
  obj.applyAccidentals = function(note) {
    for (var i = 0; i < note.keyProps.length; i++) {
      var accidental = note.keyProps[i].accidental;
      if (accidental) {
        note.addAccidental(i, new Vex.Flow.Accidental(accidental));
      }
    }
  };

  return obj;
};

var Translator = function(dom) {
  var VF = Vex.Flow;
  var renderer = new VF.Renderer(dom, VF.Renderer.Backends.CANVAS);
  var factory = new VexFactory();
  var obj = {
    vf: VF,
    renderer: renderer,
    dom: dom,
    notes: [],
    factory: factory,
    clef: "treble",
    timeSignature: "4/4"
  };

  obj.setClef = function(clef, timeSignature) {
    this.clef = clef;
    this.timeSignature = timeSignature;
  };

  obj.appendNote = function(notes) {
    /* 添加一个小节的音符 */
    var note = notes.map(n => {
      var params = {};
      var duration = n.duration;
      var element = new VF.StaveNote(n);
      // 添加升降符
      this.factory.applyAccidentals(element);
      // note structure
      params["note"] = element;
      params["noteWidth"] = CONSTANT.elementWidth[duration];
      return params;
    });
    this.notes.push(note);
  };

  obj.setContextSize = function(width, height) {
    var context = this.dom;
    console.log(context);

    context.width = width;
    context.height = height;
  };

  obj.render = function() {
    var context = this.renderer.getContext();
    var clientWidth = 0;
    var lineHeight = 250;
    var originX = 10;
    var offX = originX;
    var offY = 0;
    var allWidths = [];

    for (let index = 0; index < this.notes.length; index++) {
      const note = this.notes[index];
      var staveWidth = 0;
      if (offX + width > Util.getClientWidth()) {
        offX = originX;
        offY += lineHeight;
      }
      for (let idx = 0; idx < note.length; idx++) {
        const notationNote = note[idx];
        staveWidth += notationNote.noteWidth;
      }
      allWidths.push(staveWidth);
      clientWidth += staveWidth;
    }

    this.setContextSize(Util.getClientWidth() + 50, lineHeight+=lineHeight);

    lineHeight = 200;
    offX = originX;
    offY = 0;
    
    for (let index = 0; index < this.notes.length; index++) {
      const note = this.notes[index];
      var width = allWidths[index];
      if (offX + width > Util.getClientWidth()) {
        offX = originX;
        offY += lineHeight;
      }
      var stave = new this.factory.createStave(offX, offY, width); // 创建普表
      offX += width;
      if (index === 0) {
        // 如果是第一小节，添加谱号与节拍
        stave.addClef(this.clef);
        stave.addTimeSignature(this.timeSignature);
      }
      stave.setMeasure(index); // 设置上标
      // stave.addKeySignature('A');
      if (index === this.notes.length - 1) {
        stave.setEndBarType(VF.Barline.type.END);
      }
      stave.setContext(context).draw();
      VF.Formatter.FormatAndDraw(context, stave, note.map(e => e.note));
    }
  };

  return obj;
};

function renderVex(commandString) {
  // console.log(commandString);
  var notesArray = JSON.parse(commandString);
  var dom = document.getElementById("boo");
  var translator = new Translator(dom);

  notesArray.forEach(notes => {
    translator.appendNote(notes);
  });
  translator.render();
}
