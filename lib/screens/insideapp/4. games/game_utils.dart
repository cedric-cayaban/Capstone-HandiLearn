import 'package:flutter/material.dart';
import 'dart:math';

class Game {
  final Color hiddenCard = Colors.red;
  List<Color>? gameColors;
  List<String>? gameImg;
  List<Color> cards = [
    Colors.green,
    Colors.yellow,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.blue
  ];
  final String hiddenCardpath = "assets/insideApp/games/1/hidden.png";

  // List of card image paths
  List<String> cards_list = [
    "assets/insideApp/games/1/b.png",
    "assets/insideApp/games/1/q.png",
    "assets/insideApp/games/1/f.png",
    "assets/insideApp/games/1/o.png",
    "assets/insideApp/games/1/c.png",
    "assets/insideApp/games/1/o.png",
    "assets/insideApp/games/1/q.png",
    "assets/insideApp/games/1/c.png",
    "assets/insideApp/games/1/f.png",
    "assets/insideApp/games/1/j.png",
    "assets/insideApp/games/1/b.png",
    "assets/insideApp/games/1/j.png",
  ];

  final int cardCount = 12;
  List<Map<int, String>> matchCheck = [];

  // Methods
  void initGame() {
    // Randomize the card list
    cards_list.shuffle();

    // Initialize game colors and images
    gameColors = List.generate(cardCount, (index) => hiddenCard);
    gameImg = List.generate(cardCount, (index) => hiddenCardpath);
  }
}
