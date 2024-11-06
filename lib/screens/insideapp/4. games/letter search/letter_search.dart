import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/letter%20search/levels/easy.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/letter%20search/levels/hard.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/letter%20search/levels/medium.dart';

class LetterSearch extends StatefulWidget {
  const LetterSearch({required this.difficulty, super.key});
  final String difficulty;

  @override
  State<LetterSearch> createState() => _LetterSearchState();
}

class _LetterSearchState extends State<LetterSearch> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Widget selectLevel() {
    switch (widget.difficulty) {
      case 'Easy':
        return const LetterSearchEasy();
      case 'Normal':
        return const LetterSearchMedium();
      case 'Hard':
        return const LetterSearchHard();
      default:
        return const Center(child: Text('Invalid difficulty level'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return selectLevel();
  }
}
