import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/game_utils.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/info_card.dart'; // Import your game logic

class Game1 extends StatefulWidget {
  const Game1({Key? key}) : super(key: key);

  @override
  _Game1State createState() => _Game1State();
}

class _Game1State extends State<Game1> {
  TextStyle whiteText = TextStyle(color: Colors.white);
  bool hideTest = false;
  Game _game = Game();

  int tries = 0;
  int score = 0;
  int flag = 0;
  bool condition = false;
  bool canTap = true; // This flag prevents more taps until comparison is done

  @override
  void initState() {
    super.initState();
    _game.initGame(); // Initialize the game
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
          title: Text('Game of Memory'),
          centerTitle: true,
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
            SizedBox(
              height: 24.0,
            ),
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
                  crossAxisCount:
                      4, // Adjust this based on screen size if needed
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
                              _game.gameImg![index] = _game.cards_list[index];
                              _game.matchCheck
                                  .add({index: _game.cards_list[index]});
                            });

                            if (_game.matchCheck.length == 2) {
                              setState(() {
                                canTap =
                                    false; // Prevent further taps while checking
                              });

                              if (_game.matchCheck[0].values.first ==
                                  _game.matchCheck[1].values.first) {
                                flag++;
                                if (flag == 6) {
                                  condition = true;
                                }
                                score += 100;
                                _game.matchCheck.clear();
                              } else {
                                await Future.delayed(
                                    Duration(milliseconds: 500));
                                setState(() {
                                  _game.gameImg![_game.matchCheck[0].keys
                                      .first] = _game.hiddenCardpath;
                                  _game.gameImg![_game.matchCheck[1].keys
                                      .first] = _game.hiddenCardpath;
                                  _game.matchCheck.clear();
                                });
                              }

                              setState(() {
                                canTap =
                                    true; // Re-enable tapping after the delay
                              });
                            }
                          }
                        : null, // Disable taps when checking for a match
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
