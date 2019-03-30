// 一个数组的
window.onload = function() {
    var dom = document.getElementById("boo");
    var translator = new VexTranslator(dom);
    translator.setClef("treble", "4/4");
    translator.addNote("treble", ["c/4"], "q");
    translator.addNote("treble", ["c/4"], "q");
    translator.addNote("treble", ["c/4"], "q");
    translator.addNote("treble", ["c/4", "e/4", "g/4"], "q");
    translator.render();
    console.log(translator.dom.clientWidth);
  };