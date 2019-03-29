window.onload = function() {
  var dom = document.getElementById("boo");
  var renderer = testRenderContext(dom);
  var stave = testClef(renderer);
  // testClefNode(renderer, stave);
  // testNoteAccidentalsAndDots(renderer, stave)
  // testDrawSingleNote(renderer, stave, "c/5");
  // testBeamNotes(renderer, stave);
  // testBeamNotes2(renderer, stave);
  // testTies(renderer, stave);
  // testGuitarTablature(renderer);
  testEasyScore();
};
