// 一个数组的
window.onload = function() {
//   var dom = document.getElementById("boo");
//   var translator = new Translator(dom);
//   translator.appendNote([
//      { keys: ['d/4'], duration: 'q', addDot: true,'clef': 'treble' },
//      { keys: ['c/4'], duration: 'q' },
//      { keys: ['c/4', 'e/4', 'g/4'], duration: 'q' },
//      { keys: ['c/4', 'e/4', 'g/4'], duration: 'q' },
//   ]);
//   translator.appendNote([
//     { keys: ['d/4'], duration: 'q', addDot: true,'clef': 'treble' },
//     { keys: ['c/4'], duration: 'q' },
//     { keys: ['c/4', 'e/4', 'g/4'], duration: 'q' },
//     { keys: ['c/4', 'e/4', 'g/4'], duration: 'q' },
//  ]);
//  translator.appendNote([
//   { keys: ['d/4'], duration: 'q', addDot: true,'clef': 'treble' },
//   { keys: ['c/4'], duration: 'q' },
//   { keys: ['c/4', 'e/4', 'g/4'], duration: 'q' },
//   { keys: ['c/4', 'e/4', 'g/4'], duration: 'q' },
// ]);
//   translator.render();

};


function renderVex(commandString) {
  // console.log(commandString);
  var notesArray = JSON.parse(commandString);
  var dom = document.getElementById('boo');
  var translator = new Translator(dom);

  notesArray.forEach(notes => {
    translator.appendNote(notes);
  });
  translator.render();
}