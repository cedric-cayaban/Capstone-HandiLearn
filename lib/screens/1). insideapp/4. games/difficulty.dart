import 'package:flutter/material.dart';
import 'package:test_drawing/screens/1).%20insideapp/4.%20games/game_selection.dart';
import 'package:test_drawing/screens/1).%20insideapp/4.%20games/letter%20search/letter_search.dart';
import 'package:test_drawing/screens/1).%20insideapp/4.%20games/memory%20game/memory_game.dart';
import 'package:test_drawing/screens/1).%20insideapp/4.%20games/pictoword/picto.dart';
import 'package:test_drawing/screens/1).%20insideapp/4.%20games/quiz%20game/quiz.dart';
import 'package:test_drawing/screens/1).%20insideapp/4.%20games/sliding%20puzzle/Sliding_puzzle.dart';
import 'package:test_drawing/screens/1).%20insideapp/4.%20games/word%20search/word_search.dart';

import 'package:test_drawing/screens/insideapp/4.%20games/modal/ins1.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/modal/ins2.dart';

class DifficultyScreen extends StatefulWidget {
  DifficultyScreen({required this.game, super.key});

  final String game;
  @override
  _DifficultyScreenState createState() => _DifficultyScreenState();
}

class _DifficultyScreenState extends State<DifficultyScreen> {
  double _currentSliderValue = 1;
  String _difficultyLabel = "Easy";
  Color _backgroundColor = Color(0xFF8DD97F);
  String emoji = "assets/insideApp/games/EASY.png";

  void _updateDifficulty() {
    setState(() {
      if (_currentSliderValue < 1.5) {
        _difficultyLabel = "Easy";
        _backgroundColor = Color(0xFF8DD97F);

        emoji = "assets/insideApp/games/EASY.png";
      } else if (_currentSliderValue < 2.5) {
        _difficultyLabel = "Normal";

        _backgroundColor = Color(0xFFE6DB7D);
        emoji = "assets/insideApp/games/NORMAL.png";
      } else {
        _difficultyLabel = "Hard";
        _backgroundColor = Color(0xFFE55A5A);
        emoji = "assets/insideApp/games/HARD.png";
      }
    });
  }

  void navigateToGame(String difficulty) {
    print('natatawag');
    print(widget.game);
    print(difficulty);

    if (widget.game == 'sliding_game') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => SlidingPuzzle(difficulty: difficulty),
        ),
      );
    } else if (widget.game == 'pictoword') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => Pictoword(difficulty: difficulty),
        ),
      );
    } else if (widget.game == 'letter_search') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LetterSearch(difficulty: difficulty),
      ));
    } else if (widget.game == 'memory_game') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => MemoryGame(difficulty: difficulty),
        ),
      );
    } else if (widget.game == 'word_search') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => WordSearch(difficulty: difficulty),
        ),
      );
    } else if (widget.game == 'quiz_game') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => Quiz(difficulty: difficulty),
        ),
      );
    }
  }

  final PageController _controller = PageController();

  void modal() {
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
                bool onLastPage = false;
                bool onFirstPage = true;

                return Stack(
                  children: [
                    SizedBox(
                      height: 300,
                      width: 200,
                      child: PageView(
                        controller: _controller,
                        onPageChanged: (index) {
                          setDialogState(() {
                            onLastPage = (index == 1);
                            onFirstPage = (index == 0);
                          });
                        },
                        children: [
                          Ins1(),
                          Ins2(),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 130,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        icon: Icon(Icons.arrow_forward),
                      ),
                    ),
                    Positioned(
                      top: 130,
                      left: 0,
                      child: IconButton(
                        onPressed: () {
                          _controller.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        icon: Icon(Icons.arrow_back),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              emoji,
              height: 120,
              width: 120,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 20),
            Container(
              height: MediaQuery.of(context).size.height * .50,
              width: MediaQuery.of(context).size.width * .80,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    _difficultyLabel,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: _backgroundColor.withOpacity(0.9),
                          inactiveTrackColor: Colors.white,
                          trackShape: RoundedRectSliderTrackShape(),
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 20.0),
                          thumbColor: _backgroundColor,
                          overlayColor: _backgroundColor.withOpacity(0.2),
                          trackHeight: 25,
                          tickMarkShape: SliderTickMarkShape.noTickMark,
                        ),
                        child: Slider(
                          value: _currentSliderValue,
                          min: 1,
                          max: 3,
                          divisions: 2,
                          onChanged: (double value) {
                            setState(() {
                              _currentSliderValue = value;
                              _updateDifficulty();
                            });
                          },
                        ),
                      ),
                      Text(
                        "Drag to adjust difficulty",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                  Container(
                    height: 70,
                    width: 150,
                    decoration: BoxDecoration(
                      color: _backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.1), // Shadow color with opacity
                          spreadRadius: 2, // Spread of the shadow
                          blurRadius: 10, // Blur effect for the shadow
                          offset: Offset(0, 4), // Position of the shadow (x, y)
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        navigateToGame(_difficultyLabel);
                      },
                      child: Center(
                        child: Text(
                          'PLAY',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 30),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => Games()));
              },
              icon: Icon(Icons.arrow_back, color: Colors.black),
              label: Text(
                "Back",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
