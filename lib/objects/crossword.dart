class CrosswordAnswer {
  final String answer;
  final List<int> answerLines; // Stores the indices of the word in the puzzle
  final int indexArray; // The index of the word in the list
  bool done; // Indicates whether the word has been found

  CrosswordAnswer({
    required this.answer,
    required this.answerLines,
    required this.indexArray,
    this.done = false,
  });

  @override
  String toString() {
    return '$answer (Lines: ${answerLines.join(', ')}, Done: $done)';
  }
}

class CurrentDragObj {
  int indexArrayOnTouch = -1; // Tracks the index of the word the user touched
  List<int> currentDragLine = []; // Tracks the current line of characters being dragged

  CurrentDragObj({this.indexArrayOnTouch = -1});
}

