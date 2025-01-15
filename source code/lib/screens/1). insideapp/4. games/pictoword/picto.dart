import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:test_drawing/screens/1).%20insideapp/4.%20games/game_selection.dart';

class Pictoword extends StatefulWidget {
  Pictoword({required this.difficulty, super.key});

  final String difficulty;

  @override
  _PictowordState createState() => _PictowordState();
}

class _PictowordState extends State<Pictoword> with TickerProviderStateMixin {
  late List<String?> blankTiles;
  late List<String> letters;
  late String correctAnswer;
  late int tilesNum;
  late String imagePicto;
  late String hint;
  Set<String> usedLetters = {};

  final Map<int, AnimationController> _animationControllers = {};
  final Map<int, Animation<double>> _animations = {};

  @override
  void initState() {
    super.initState();
    // Initialize game settings based on difficulty
    initializeGame();
    blankTiles = List<String?>.filled(correctAnswer.length, null);
    letters = generateRandomLetters().split('');
  }

  List<Map<String, dynamic>> questions = [
    // Easy
    {
      "difficulty": "Easy",
      "imagePicto": "assets/insideApp/games/2/cat.png",
      "hint": "I am a pet that purrs and chases mice. Who am I?",
      "answer": "CAT",
    },
    {
      "difficulty": "Easy",
      "imagePicto": "assets/insideApp/games/2/dog.png",
      "hint": "I love barking and wagging my tail. Who am I?",
      "answer": "DOG",
    },
    {
      "difficulty": "Easy",
      "imagePicto": "assets/insideApp/games/2/pig.png",
      "hint": "I roll in mud and say 'oink.' Who am I?",
      "answer": "PIG",
    },
    // Normal
    {
      "difficulty": "Normal",
      "imagePicto": "assets/insideApp/games/2/bike.png",
      "hint": "I have two wheels, and you pedal me. What am I?",
      "answer": "BIKE",
    },
    {
      "difficulty": "Normal",
      "imagePicto": "assets/insideApp/games/2/kite.png",
      "hint": "I fly high in the sky with strings. What am I?",
      "answer": "KITE",
    },
    {
      "difficulty": "Normal",
      "imagePicto": "assets/insideApp/games/2/bag.png",
      "hint": "I carry your books and lunch. What am I?",
      "answer": "BAG",
    },
    // Hard
    {
      "difficulty": "Hard",
      "imagePicto": "assets/insideApp/games/2/apple.png",
      "hint": "I am a fruit that keeps the doctor away. What am I?",
      "answer": "APPLE",
    },
    {
      "difficulty": "Hard",
      "imagePicto": "assets/insideApp/games/2/book.png",
      "hint": "I contain knowledge and stories. What am I?",
      "answer": "BOOK",
    },
    {
      "difficulty": "Hard",
      "imagePicto": "assets/insideApp/games/2/chair.png",
      "hint": "You sit on me every day. What am I?",
      "answer": "CHAIR",
    },
  ];

  void initializeGame() {
    final random = Random();

    // Filter questions by difficulty
    var filteredQuestions =
        questions.where((q) => q['difficulty'] == widget.difficulty).toList();

    // Pick a random question
    if (filteredQuestions.isNotEmpty) {
      int randomIndex = random.nextInt(filteredQuestions.length);
      var selectedQuestion = filteredQuestions[randomIndex];

      correctAnswer = selectedQuestion["answer"]!;
      imagePicto = selectedQuestion["imagePicto"]!;
      hint = selectedQuestion["hint"]!;
      tilesNum = widget.difficulty == "Easy"
          ? 3
          : widget.difficulty == "Normal"
              ? 6
              : 8;
    } else {
      print('No questions available for the selected difficulty.');
    }
  }

  String generateRandomLetters() {
    const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final random = Random();
    String randomLetters = correctAnswer;
    Set<String> usedLetters = correctAnswer.split('').toSet();

    // Generate unique letters
    while (randomLetters.length < tilesNum) {
      String letter = alphabet[random.nextInt(alphabet.length)];
      if (!usedLetters.contains(letter)) {
        randomLetters += letter;
        usedLetters.add(letter);
      }
    }

    List<String> lettersList = randomLetters.split('');
    lettersList.shuffle(random);
    return lettersList.join();
  }

  var gameInstruction = [
    {
      'title': 'Look at the Photos',
      'text':
          'At the top of the screen, you’ll see four photos. Look at them carefully to figure out what they have in common.',
    },
    {
      'title': 'Guess the Word',
      'text':
          "Think about the word that describes all the photos. In this example, it could be the name of the animal in the pictures.",
    },
    {
      'title': 'Choose the Letters',
      'text':
          "Below the photos, there are some letters. Tap on each letter to spell out the word you think is the answer.",
    },
    {
      'title': 'Use Hints',
      'text': "If you’re stuck, tap the 'Hint' button to get some help.",
    },
    {
      'title': 'Clear if Needed',
      'text':
          "If you want to start over, tap the 'Clear' button to remove the letters and try again.",
    },
    {
      'title': 'Have Fun!',
      'text':
          "Keep playing to guess more words and have fun learning new things!",
    },
  ];
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < gameInstruction.length) {
      _controller.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _controller.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void loadInstructions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
          ),
          child: AlertDialog(
            backgroundColor: Colors.white,
            contentPadding: EdgeInsets.all(16),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setDialogState) {
                return SingleChildScrollView(
                  child: SizedBox(
                    height: 350,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView(
                            controller: _controller,
                            onPageChanged: (index) {
                              setDialogState(() {
                                _currentPage = index;
                              });
                            },
                            children: [
                              ...List.generate(gameInstruction.length, (index) {
                                return Column(
                                  // Align content to the start
                                  children: [
                                    Text(
                                      gameInstruction[index]['title']!,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 23,
                                      ),
                                    ),
                                    Gap(20),
                                    Image.asset(
                                      'assets/insideApp/games/2/picto${index + 1}.png',
                                      width:
                                          200, // Adjust image size to fit better
                                      height: 100,
                                      fit: BoxFit.fill,
                                    ),
                                    Gap(20),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        gameInstruction[index]['text']!,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              // WordSearchTip1(),
                              // WordSearchTip2(),
                              // WordSearchTip3(),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed:
                                  _currentPage > 0 ? _previousPage : null,
                              icon: Icon(Icons.arrow_back),
                              color:
                                  _currentPage > 0 ? Colors.blue : Colors.grey,
                            ),
                            Text(' ${_currentPage + 1}'),
                            IconButton(
                              onPressed: _currentPage < gameInstruction.length
                                  ? _nextPage
                                  : null,
                              icon: Icon(Icons.arrow_forward),
                              color: _currentPage < gameInstruction.length - 1
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    ).then((_) {
      // Reset the current page to 0 when the dialog is closed
      setState(() {
        _currentPage = 0;
      });
    });
  }

  @override
  void dispose() {
    // Dispose all individual animation controllers
    for (var controller in _animationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (_) => Games()));
            },
            icon: Image.asset(
                height: MediaQuery.of(context).size.height * 0.045,
                "assets/insideApp/close.png"),
          ),
          actions: [
            IconButton(
              onPressed: () {
                loadInstructions();
              },
              icon: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset(
                      height: MediaQuery.of(context).size.height * 0.05,
                      "assets/insideApp/games/instruction.png"),
                ),
              ),
            ),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/insideApp/games/2/pictoword-bg.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 50,
                child: Image.asset(
                  imagePicto,
                  height: MediaQuery.of(context).size.height * .48,
                  width: MediaQuery.of(context).size.width * .9,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * .34,
                left: 0,
                right: 0,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(
                      correctAnswer.length, (index) => buildBlankTile(index)),
                ),
              ),
              Positioned(
                bottom: tilesNum > 3
                    ? MediaQuery.of(context).size.height * .08
                    : MediaQuery.of(context).size.height * .04,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: tilesNum > 6 ? 6.0 : 36, vertical: 8.0),
                  child: Container(
                    // decoration: BoxDecoration(color: Colors.red),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * .24,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              tilesNum > 3 ? tilesNum ~/ 2 : tilesNum,
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: tilesNum,
                        itemBuilder: (context, index) {
                          return buildLetterBox(index, letters[index]);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 40,
                child: InkWell(
                  onTap: clearBlankTiles,
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: MediaQuery.of(context).size.width * .30,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color(0xFFb3c3b9),
                        )),
                    child: Text('Clear',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ),
              Positioned(
                right: 40,
                bottom: 10,
                child: InkWell(
                  onTap: () {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.info,
                        title: "Hint",
                        text: hint);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: MediaQuery.of(context).size.width * .30,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color(0xFFb3c3b9),
                        )),
                    child: Text('Hint',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Track the indexes of the used letters
  Set<int> usedIndexes = {};

  Widget buildLetterBox(int index, String letter) {
    bool isUsed = usedIndexes.contains(index);

    // Initialize the animation for this tile if it doesn't exist
    if (!_animationControllers.containsKey(index)) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 100),
        vsync: this,
      );
      _animationControllers[index] = controller;
      _animations[index] = Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }

    return GestureDetector(
      onTap: isUsed
          ? null
          : () {
              if (blankTiles.contains(null)) {
                placeLetterInBlankTile(letter);
                usedIndexes
                    .add(index); // Mark this specific letter index as used

                // Trigger the animation for the tapped tile only
                _animationControllers[index]!
                    .forward()
                    .then((_) => _animationControllers[index]!.reverse());
              }
            },
      child: ScaleTransition(
        scale: _animations[index]!,
        child: Opacity(
          opacity: isUsed ? 0.4 : 1.0,
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(tilesNum > 2 ? 8 : 4.0),
            ),
            child: Text(
              letter,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBlankTile(int index) {
    return GestureDetector(
      onTap: () {
        if (blankTiles[index] != null) {
          returnLetterToBottom(index);
        }
      },
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: blankTiles[index] == null ? Colors.grey[300] : Colors.blue,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Text(blankTiles[index] ?? '',
            style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
    );
  }

  void placeLetterInBlankTile(String letter) {
    final emptyIndex = blankTiles.indexOf(null);
    if (emptyIndex != -1) {
      setState(() {
        blankTiles[emptyIndex] = letter;
        usedLetters.add(letter);
      });

      if (!blankTiles.contains(null)) {
        if (blankTiles.join() == correctAnswer) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'Congratulations!',
            text: 'You got the correct answer!',
            confirmBtnColor: Colors.greenAccent.shade700,
            onConfirmBtnTap: () {
              clearBlankTiles();
              Navigator.of(context).pop();
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (_) => Games()));
            },
          );
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Try again!',
            text: "Your answer is incorrect",
            confirmBtnColor: Colors.orange,
            onConfirmBtnTap: () {
              clearBlankTiles();
              Navigator.of(context).pop();
            },
          );
        }
      }
    }
  }

  void returnLetterToBottom(int index) {
    setState(() {
      String? letter = blankTiles[index];
      if (letter != null) {
        // Remove letter from usedLetters and reset its index in usedIndexes
        usedLetters.remove(letter);
        blankTiles[index] = null;

        // Find the index of the letter in the original letter list and remove it from usedIndexes
        int originalIndex = letters.indexOf(letter);
        if (originalIndex != -1) {
          usedIndexes.remove(originalIndex);
        }
      }
    });
  }

  void clearBlankTiles() {
    setState(() {
      blankTiles = List<String?>.filled(correctAnswer.length, null);
      usedLetters.clear();
      usedIndexes.clear(); // Reset all used indexes
    });
  }
}
