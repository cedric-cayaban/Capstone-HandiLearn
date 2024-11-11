import 'package:test_drawing/objects/progress.dart';

List<List<Progress>> categoryList = [
  // LETTERS
  [
    Progress(name: 'Capital Letters_Pronounce', total: 26),
    Progress(name: 'Capital Letters_Write', total: 26),
    Progress(name: 'Small Letters_Write', total: 26),
  ],

  // WORDS
  [
    Progress(name: 'Words_Pronounce', total: 10),
    Progress(name: 'Words_Write', total: 10),
    Progress(name: 'Cursive Words_Write', total: 10),
  ],

  // NUMBERS
  [
    Progress(name: 'Numbers_Pronounce', total: 10),
    Progress(name: 'Numbers_Write', total: 10),
  ],

  // CURSIVES
  [
    //Progress(name: 'Capital Cursives_Pronounce', total: 26),
    Progress(name: 'Capital Cursives_Write', total: 26),
    Progress(name: 'Small Cursives_Write', total: 26),
  ],
];
List<List<String>> categoryNames = [
  // LETTERS
  [
    'Pronounce Letters',
    'Write Capital Letters',
    'Write Small Letters',
  ],

  // WORDS
  [
    'Pronounce Words',
    'Write Words',
    'Write Cursive Words',
  ],

  // NUMBERS
  [
    'Pronounce Numbers',
    'Write Numbers',
  ],

  // CURSIVES
  [
    //'Pronounce Cursives',
    'Write Capital Cursives',
    'Write Small Cursives',
  ],
];
