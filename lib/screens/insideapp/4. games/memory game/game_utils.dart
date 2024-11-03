import 'package:flutter/material.dart';
import 'dart:math';

class Game {
  final Color hiddenCard = Colors.red;
  List<Color>? gameColors;
  List<String>? gameImg;
  List<String> cardsList = []; // Holds pairs of card image paths
  final String hiddenCardPath = "assets/insideApp/games/memory game/hidden.png";
  List<Map<int, String>> matchCheck = [];
  int gridSize;
  int cardCount = 0;
  int matchPairs = 0; // Number of pairs to match to win

  Game({required this.gridSize}) {
    cardCount = gridSize * gridSize;
    matchPairs = cardCount ~/ 2;
    _generateCardPairs();
  }

  // Generate pairs of cards based on grid size
  void _generateCardPairs() {
    List<String> availableCards = [
      "assets/insideApp/games/memory game/b.png",
      "assets/insideApp/games/memory game/q.png",
      "assets/insideApp/games/memory game/f.png",
      "assets/insideApp/games/memory game/o.png",
      "assets/insideApp/games/memory game/c.png",
      "assets/insideApp/games/memory game/j.png"
    ];

    int numPairs = cardCount ~/ 2;
    cardsList = availableCards.take(numPairs).expand((path) => [path, path]).toList();
  }

  // Initialize the game board
  void initGame() {
    cardsList.shuffle();
    gameColors = List.generate(cardCount, (index) => hiddenCard);
    gameImg = List.generate(cardCount, (index) => hiddenCardPath);
  }
}
