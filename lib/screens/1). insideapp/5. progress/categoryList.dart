import 'package:test_drawing/objects/progress.dart';

List<List<Progress>> categoryList = [
  // LETTERS
  [
    Progress(name: 'Capital Letters_Reading', total: 26),
    Progress(name: 'Capital Letters_Writing', total: 26),
    Progress(name: 'Small Letters_Writing', total: 26),
  ],

  // WORDS
  [
    Progress(name: 'Words_Reading', total: 10),
    Progress(name: 'Words_Writing', total: 10),
    Progress(name: 'Cursive Words_Writing', total: 10),
  ],

  // NUMBERS
  [
    Progress(name: 'Numbers_Reading', total: 10),
    Progress(name: 'Numbers_Writing', total: 10),
  ],

  // CURSIVES
  [
    //Progress(name: 'Capital Cursives_Reading', total: 26),
    Progress(name: 'Capital Cursives_Writing', total: 26),
    Progress(name: 'Small Cursives_Writing', total: 26),
  ],
];
List<List<String>> categoryNames = [
  // LETTERS
  [
    'Reading Letters',
    'Writing Capital Letters',
    'Writing Small Letters',
  ],

  // WORDS
  [
    'Reading Words',
    'Writing Words',
    'Writing Cursive Words',
  ],

  // NUMBERS
  [
    'Reading Numbers',
    'Writing Numbers',
  ],

  // CURSIVES
  [
    //'Reading Cursives',
    'Writing Capital Cursives',
    'Writing Small Cursives',
  ],
];
