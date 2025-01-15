import 'dart:math';

import 'package:flutter/material.dart';

class Game {
  final Color hiddenCard = Colors.red;
  List<Color>? gameColors;
  List<String>? gameImg;
  List<String> cardsList = []; // Holds pairs of card image paths
  final String hiddenCardPath = "assets/insideApp/games/memory game/hidden.png";
  List<Map<int, String>> matchCheck = [];
  int gridSize;
  int cardCount; // Number of cards based on difficulty
  int matchPairs; // Number of pairs to match to win

  Game({required this.gridSize, required this.cardCount})
      : matchPairs = cardCount ~/ 2 {
    _generateCardPairs();
  }

  // Generate pairs of cards based on card count
  void _generateCardPairs() {
    List<String> availableCards = [
      "assets/insideApp/games/memory game/a.png",
      "assets/insideApp/games/memory game/b.png",
      "assets/insideApp/games/memory game/c.png",
      "assets/insideApp/games/memory game/d.png",
      "assets/insideApp/games/memory game/e.png",
      "assets/insideApp/games/memory game/f.png",
      "assets/insideApp/games/memory game/g.png",
      "assets/insideApp/games/memory game/q.png",
      "assets/insideApp/games/memory game/o.png",
      "assets/insideApp/games/memory game/j.png"
    ];

    availableCards.shuffle();

    int numPairs = cardCount ~/ 2;
    cardsList =
        availableCards.take(numPairs).expand((path) => [path, path]).toList();
  }

  // Initialize the game board
  void initGame() {
    cardsList.shuffle();
    gameColors = List.generate(cardCount, (index) => hiddenCard);
    gameImg = List.generate(cardCount, (index) => hiddenCardPath);
  }
}
