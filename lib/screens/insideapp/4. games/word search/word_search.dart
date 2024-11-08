import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/letter%20search/levels/easy.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/letter%20search/levels/hard.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/letter%20search/levels/medium.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/word%20search/levels/easy.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/word%20search/levels/hard.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/word%20search/levels/medium.dart';

class WordSearch extends StatefulWidget {
  const WordSearch({required this.difficulty, super.key});
  final String difficulty;

  @override
  State<WordSearch> createState() => _WordSearchState();
}

class _WordSearchState extends State<WordSearch> {
  @override
  void initState() {
    super.initState();

  }

 void dispose() {
    // Reset the orientation to the default system orientation (or another specific one)
    super.dispose();
  }

  Widget selectLevel() {
    switch (widget.difficulty) {
      case 'Easy':
        return const WordSearchEasy();
      case 'Normal':
        return const WordSearchMedium();
      case 'Hard':
        return const WordSearchHard();
      default:
        return const Center(child: Text('Invalid difficulty level'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return selectLevel();
  }
}
