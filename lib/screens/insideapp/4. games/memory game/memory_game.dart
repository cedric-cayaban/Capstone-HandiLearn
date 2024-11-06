import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/memory%20game/game_utils.dart';

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
      gridSize = 4; // 2x4 grid for 8 cards
      _game = Game(gridSize: gridSize, cardCount: 8);
    }
    _game.initGame();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFC3EEFF),
        appBar: AppBar(
          backgroundColor: Color(0xFF0C6699),
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 30,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Memory Game",
                style: TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0C6699),
                ),
              ),
            ),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                info_card("Tries", "$tries"),
                info_card("Score", "$score"),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: GridView.builder(
                itemCount: _game.gameImg!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                padding: EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: canTap
                        ? () async {
                            setState(() {
                              tries++;
                              _game.gameImg![index] = _game.cardsList[index];
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
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFB46A),
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: AssetImage(_game.gameImg![index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Builder(
              builder: (context) {
                if (condition) {
                  Future.delayed(Duration.zero, () {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      title: 'Good Job!',
                      text: 'Find more games.',
                    );
                  });
                }
                return SizedBox.shrink();
              },
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
