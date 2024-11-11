import 'package:flutter/material.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/game_selection.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/pictoword/picto.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/letter%20search/letter_search.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/memory%20game/memory_game.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/quiz%20game/quiz.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/sliding%20puzzle/Sliding_puzzle.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/word%20search/word_search.dart';
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
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => WordSearch(difficulty: difficulty),
        ),
      );
    } else if (widget.game == 'quiz_game') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => Quiz(difficulty: difficulty),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SELECT DIFFICULTY'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) => Games()));
          },
        ),
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
