import 'dart:math';

import 'package:flutter/material.dart';
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

  void initializeGame() {
    // Set correctAnswer and other properties based on difficulty
    if (widget.difficulty == "Easy") {
      correctAnswer = "PIG";
      tilesNum = 3;
      imagePicto = "assets/insideApp/games/2/pig.png";
      hint =
          "This animal loves to roll in the mud and says 'oink oink!' Can you guess what it is?";
    } else if (widget.difficulty == "Normal") {
      correctAnswer = "BAG";
      tilesNum = 6;
      imagePicto = "assets/insideApp/games/2/bag.png";
      hint =
          "You carry your lunch and books in this. It hangs over your shoulder. What could it be?";
    } else {
      correctAnswer = "BIKE";
      tilesNum = 8;
      imagePicto = "assets/insideApp/games/2/bike.png";
      hint =
          "With two wheels, you can pedal fast and wear a helmet for safety. What is it?";
    }
  }

  String generateRandomLetters() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final random = Random();
    String randomLetters = correctAnswer;
    Set<String> usedLetters = correctAnswer.split('').toSet();

    // Generate unique random letters until reaching tilesNum
    while (randomLetters.length < tilesNum) {
      String letter = letters[random.nextInt(letters.length)];
      if (!usedLetters.contains(letter)) {
        randomLetters += letter;
        usedLetters.add(letter);
      }
    }

    List<String> lettersList = randomLetters.split('');
    lettersList.shuffle(random);
    return lettersList.join();
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
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (_) => Games()));
            },
          ),
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

  Widget buildLetterBox(int index, String letter) {
    bool isUsed = usedLetters.contains(letter);

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
        usedLetters.remove(letter);
        blankTiles[index] = null;
      }
    });
  }

  void clearBlankTiles() {
    setState(() {
      blankTiles = List<String?>.filled(correctAnswer.length, null);
      usedLetters.clear();
    });
  }
}
