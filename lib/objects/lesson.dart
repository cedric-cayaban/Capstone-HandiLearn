class Lesson {
  Lesson({
    required this.character,
    required this.svgPath,
    required this.type,
    required this.isCapital,
  });

  String character;
  String svgPath;
  String type; //STANDARD - CURSIVE - NUMBER - WORD
  bool isCapital;
}
