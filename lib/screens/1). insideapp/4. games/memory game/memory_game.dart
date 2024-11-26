import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:test_drawing/screens/1).%20insideapp/4.%20games/game_selection.dart';
import 'package:test_drawing/screens/1).%20insideapp/4.%20games/memory%20game/game_utils.dart';

class MemoryGame extends StatefulWidget {
  const MemoryGame({Key? key, required this.difficulty}) : super(key: key);

  final String difficulty;

  @override
  _MemoryGameState createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  TextStyle whiteText = TextStyle(color: Colors.white);
  late Game _game;
  int tries = 0;
  int score = 0;
  int flag = 0;
  bool condition = false;
  bool canTap = true;
  late int gridSize;
  late List<bool> _isTapped;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    if (widget.difficulty == 'Easy') {
      gridSize = 2; // 2x2 grid for 4 cards
      _game = Game(gridSize: gridSize, cardCount: 4);
    } else if (widget.difficulty == 'Normal') {
      gridSize = 3; // 2x3 grid for 6 cards
      _game = Game(gridSize: gridSize, cardCount: 6);
    } else {
      gridSize = 3; // 2x4 grid for 8 cards
      _game = Game(gridSize: gridSize, cardCount: 8);
    }
    _isTapped = List.generate(_game.cardCount, (_) => false);
    _game.initGame();
  }

  var gameInstruction = [
    {
      'title': 'Look at the Cards',
      'text':
          'All the cards start face down. Tap to flip them and find matching pictures!',
    },
    {
      'title': 'Tap to Flip',
      'text':
          "Tap on a card with a question mark to flip it over and see what’s underneath.",
    },
    {
      'title': 'Find the Match',
      'text':
          "Try to remember where each picture is and find two cards that match. For example, look for two cards with the same letter or character.",
    },
    {
      'title': 'Keep Going',
      'text':
          "Once you find a matching pair, they’ll stay face-up. Keep flipping cards to find all the pairs.",
    },
    {
      'title': 'Have Fun!',
      'text': "Keep matching until all the pairs are found. Good luck!",
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
                                      'assets/insideApp/games/memory game/memory${index + 1}.png',
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Color(0xFFC3EEFF),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
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
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "assets/insideApp/games/memory game/Mind Match.png"),
                  fit: BoxFit
                      .fill, // Keep the image covering the entire background
                ),
              ),
              child: SizedBox(),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height *
                  .40, // Adjust the positioning as needed
              // left: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.2), // Shadow color with opacity
                      spreadRadius: 5, // Spread of the shadow
                      blurRadius: 10, // Blur effect for the shadow
                      offset: Offset(0, 4), // Position of the shadow (x, y)
                    ),
                  ],
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.width * .80,
                  width: MediaQuery.of(context).size.width * .80,
                  child: GridView.builder(
                    itemCount: _game.gameImg!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridSize,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    padding: EdgeInsets.all(16.0),
                    itemBuilder: (context, index) {
                      // Add item builder logic here
                      return GestureDetector(
                        onTap: canTap
                            ? () async {
                                setState(() {
                                  tries++;
                                  _isTapped[index] = true; // Start animation
                                  _game.gameImg![index] =
                                      _game.cardsList[index];
                                  _game.matchCheck
                                      .add({index: _game.cardsList[index]});
                                });

                                if (_game.matchCheck.length == 2) {
                                  setState(() {
                                    canTap = false;
                                  });

                                  if (_game.matchCheck[0].values.first ==
                                      _game.matchCheck[1].values.first) {
                                    flag++;
                                    if (flag == _game.matchPairs) {
                                      condition = true;
                                    }
                                    score += 100;
                                    _game.matchCheck.clear();
                                  } else {
                                    await Future.delayed(
                                        Duration(milliseconds: 500));
                                    setState(() {
                                      _isTapped[_game
                                          .matchCheck[0].keys.first] = false;
                                      _isTapped[_game
                                          .matchCheck[1].keys.first] = false;
                                      _game.gameImg![_game.matchCheck[0].keys
                                          .first] = _game.hiddenCardPath;
                                      _game.gameImg![_game.matchCheck[1].keys
                                          .first] = _game.hiddenCardPath;
                                      _game.matchCheck.clear();
                                    });
                                  }

                                  setState(() {
                                    canTap = true;
                                  });
                                }
                              }
                            : null,
                        child: AnimatedScale(
                          scale: _isTapped[index]
                              ? 1.0
                              : .9, // Scale up when tapped
                          duration: Duration(milliseconds: 200),
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                      0.1), // Shadow color with opacity
                                  spreadRadius: 1, // Spread of the shadow
                                  blurRadius: 2, // Blur effect for the shadow
                                  offset: Offset(
                                      0, 4), // Position of the shadow (x, y)
                                ),
                              ],
                              color: Color(0xFFFFB469),
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: AssetImage(_game.gameImg![index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ); // Placeholder
                    },
                  ),
                ),
              ),
            ),
            if (condition)
              Positioned(
                bottom:
                    0, // Adjust to place at the bottom or any specific position
                left: 0,
                right: 0,
                child: Builder(
                  builder: (context) {
                    Future.delayed(Duration.zero, () {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        title: 'Congratulations!',
                        text: "Let's play more games!",
                        confirmBtnColor: Colors.greenAccent.shade700,
                        onConfirmBtnTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => Games()));
                        },
                      );
                    });
                    return SizedBox.shrink(); // Return any widget here
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Widget info_card(String title, String info) {
  return Expanded(
    child: Container(
      margin: EdgeInsets.all(26.0),
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 26.0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6.0),
          Text(
            info,
            style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}
