import 'package:flutter/material.dart';

class Pictoword extends StatefulWidget {
  const Pictoword({Key? key, required this.difficulty}) : super(key: key);

  final String difficulty;

  @override
  _PictowordState createState() => _PictowordState();
}

class _PictowordState extends State<Pictoword> {
  int currentPuzzleIndex = 0;
  List<String> currentAnswer = [];
  List<String> letterOptions = [];

  List<Puzzle> puzzles = [
    Puzzle(
      imagePath: 'assets/insideApp/games/2/bookGame.png',
      answer: 'BOOK',
    ),
    Puzzle(
      imagePath: 'assets/insideApp/games/2/bagGame.png',
      answer: 'BAG',
    ),
    Puzzle(
      imagePath: 'assets/insideApp/games/2/chairGame.png',
      answer: 'CHAIR',
    ),
    Puzzle(
      imagePath: 'assets/insideApp/games/2/crayonsGame.png',
      answer: 'CRAYONS',
    ),
    Puzzle(
      imagePath: 'assets/insideApp/games/2/eraserGame.png',
      answer: 'ERASER',
    ),
    Puzzle(
      imagePath: 'assets/insideApp/games/2/notebookGame.png',
      answer: 'NOTEBOOK',
    ),
    Puzzle(
      imagePath: 'assets/insideApp/games/2/pencilGame.png',
      answer: 'PENCIL',
    ),
    Puzzle(
      imagePath: 'assets/insideApp/games/2/rulerGame.png',
      answer: 'RULER',
    ),
    // Add more puzzles here
  ];

  @override
  void initState() {
    super.initState();
    loadPuzzle();
  }

  void loadPuzzle() {
    setState(() {
      currentAnswer =
          List.filled(puzzles[currentPuzzleIndex].answer.length, '');
      letterOptions = generateLetterOptions(puzzles[currentPuzzleIndex].answer);
    });
  }

  List<String> generateLetterOptions(String answer) {
    // Start with the answer letters
    List<String> letters = answer.split('');

    // Add random extra letters until we have exactly 8 letters
    while (letters.length < 8) {
      // Generate a random letter from A-Z
      String randomLetter = String.fromCharCode(65 + (letters.length % 26));
      if (!letters.contains(randomLetter)) {
        letters.add(randomLetter);
      }
    }

    letters.shuffle(); // Shuffle to randomize options
    return letters;
  }

  void onLetterTap(String letter) {
    int emptyIndex = currentAnswer.indexOf('');
    if (emptyIndex != -1) {
      setState(() {
        currentAnswer[emptyIndex] = letter;
        letterOptions[letterOptions.indexOf(letter)] = '';
      });
    }
  }

  void clearAnswer() {
    setState(() {
      currentAnswer = List.filled(currentAnswer.length, '');
    });
  }

  void checkAnswer() {
    String userAnswer = currentAnswer.join();
    if (userAnswer.toUpperCase() ==
        puzzles[currentPuzzleIndex].answer.toUpperCase()) {
      // Move to the next puzzle
      setState(() {
        currentPuzzleIndex = (currentPuzzleIndex + 1) % puzzles.length;
        loadPuzzle();
      });
    } else {
      // Show a message or error feedback
      print("Incorrect Answer");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('4 Pics 1 Word')),
      body: Column(
        children: [
          // Display the single image
          Expanded(
            child: Center(
              child: Image.asset(puzzles[currentPuzzleIndex].imagePath),
            ),
          ),
          // Answer block with empty slots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: currentAnswer.map((letter) {
              return Container(
                margin: EdgeInsets.all(4.0),
                padding: EdgeInsets.all(8.0),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          // Letter grid with two rows of four letters each
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: letterOptions.sublist(0, 4).map((letter) {
                  return ElevatedButton(
                    onPressed:
                        letter.isNotEmpty ? () => onLetterTap(letter) : null,
                    child: Text(
                      letter,
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: letterOptions.sublist(4, 8).map((letter) {
                  return ElevatedButton(
                    onPressed:
                        letter.isNotEmpty ? () => onLetterTap(letter) : null,
                    child: Text(
                      letter,
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          // Submit and Clear buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: clearAnswer,
                child: Text('Clear'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: checkAnswer,
                child: Text('Submit'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Puzzle {
  final String imagePath; // Changed to a single image path
  final String answer;

  Puzzle({required this.imagePath, required this.answer});
}
