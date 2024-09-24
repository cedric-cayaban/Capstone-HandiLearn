class Lesson {
  Lesson({
    required this.character,
    required this.imgPath,
    required this.svgPath,
    required this.type,
    required this.isCapital,
  });

  String character;
  String imgPath;
  String svgPath;
  String type; //STANDARD - CURSIVE - NUMBER - WORD
  bool isCapital;
}
