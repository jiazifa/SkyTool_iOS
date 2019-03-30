var VexTranslator = function(dom) {
  var VF = Vex.Flow;
  var renderer = new VF.Renderer(dom, VF.Renderer.Backends.SVG);

  var obj = {
    vf: VF,
    renderer: renderer,
    dom: dom,
    notes: [],
    staves: [],
    bars: [],
  };

  obj.resetNotes = function() {
    app.notes = [];
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

  obj.addNote = function(clef, keys, duration) {
    var note = new VF.StaveNote({
      clef: clef,
      keys: keys,
      duration: duration
    });  
    this.notes.push(note);
    
    return note;
  };

  obj.render = function() {
    var context = this.renderer.getContext();
    console.log(this.notes);
    
    VF.Formatter.FormatAndDraw(context, this.stave, this.notes);
  };

  return obj;
};
