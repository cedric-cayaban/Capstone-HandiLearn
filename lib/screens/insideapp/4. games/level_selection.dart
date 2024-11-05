import 'package:flutter/material.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/letter%20search/letter_search.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/pictoword.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/sliding%20puzzle/Sliding_puzzle.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/sliding%20puzzle/3by3.dart';
// 3x3 puzzle

class SelectDifficulty extends StatefulWidget {
  SelectDifficulty({required this.game, super.key});

  final String game;

  @override
  State<SelectDifficulty> createState() => _SelectDifficultyState();
}

class _SelectDifficultyState extends State<SelectDifficulty> {
  void navigateToGame(String difficulty) {
    print('natatawag');
    print(widget.game);
    print(difficulty);

    if (widget.game == 'sliding_game') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SlidingPuzzle(difficulty: difficulty),
        ),
      );
    } else if (widget.game == 'pictoword') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => Pictoword(difficulty: difficulty),
        ),
      );
    } else if (widget.game == 'letter_search') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LetterSearch(difficulty: difficulty),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SELECT DIFFICULTY'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                navigateToGame('Easy');
              },
              child: Image.asset('assets/insideApp/games/EASY.png'),
            ),
            InkWell(
              onTap: () {
                navigateToGame('Normal');
              },
              child: Image.asset('assets/insideApp/games/NORMAL.png'),
            ),
            InkWell(
              onTap: () {
                navigateToGame('Hard');
              },
              child: Image.asset('assets/insideApp/games/HARD.png'),
            ),
          ],
        ),
      ),
    );
  }
}
