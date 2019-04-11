// 一个数组的
window.onload = function() {
  var dom = document.getElementById("boo");
  var translator = new Translator(dom);
  for (let index = 0; index < 1; index++) {
    translator.appendNote([
        { keys: ['d/4'], duration: 'q', addDot: true,'clef': 'treble' },
        { keys: ['c/4'], duration: 'q' },
        { keys: ['c/4', 'e/4', 'g/4'], duration: 'q' },
        { keys: ['c/4', 'e/4', 'g/4'], duration: 'q' },
     ]);
      
  }
  
  translator.render();

};
