import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:test_drawing/screens/1).%20insideapp/4.%20games/game_selection.dart';

class SlidingPuzzle extends StatefulWidget {
  SlidingPuzzle({required this.difficulty, super.key});

  final String difficulty;

  @override
  _SlidingPuzzleState createState() => _SlidingPuzzleState();
}

class _SlidingPuzzleState extends State<SlidingPuzzle> {
  late List<int> tiles;
  late int emptyTileIndex;
  late int gridSize;
  late int tileCount; // Total number of tiles based on grid size
  late String fullImageAsset;
  List<String> puzzleEasy = ['A', 'B', 'C', 'D', 'E'];
  List<String> puzzleNormal = ['a', 'b', 'c', 'd', 'e'];
  List<String> puzzleHard = ['PIG', 'CAT', 'KITE', 'ORANGE', 'APPLE'];
  late String randomItem;

  @override
  void initState() {
    super.initState();

    _randomItems();

    gridSize = widget.difficulty != 'Hard' ? 2 : 3;
    tileCount = gridSize * gridSize;
    _initializePuzzle();
  }

  void _randomItems() {
    final random = Random();
    List<String> puzzleList;
    String difficultyPath;

    if (widget.difficulty == 'Easy') {
      puzzleList = puzzleEasy;
      difficultyPath = 'EASY';
    } else if (widget.difficulty == 'Normal') {
      puzzleList = puzzleNormal;
      difficultyPath = 'NORMAL';
    } else {
      puzzleList = puzzleHard;
      difficultyPath = 'HARD';
    }

    int randomIndex = random.nextInt(puzzleList.length);
    randomItem = puzzleList[randomIndex];
    fullImageAsset =
        'assets/insideApp/games/sliding puzzle/$difficultyPath/$randomItem.png';
  }

  void _initializePuzzle() {
    tiles = List<int>.generate(tileCount, (index) => index); // Generate tiles
    tiles.shuffle(); // Shuffle the tiles
    emptyTileIndex = tiles.indexOf(tileCount - 1); // Last tile as empty
    setState(() {});
  }

  void _solvePuzzle() {
    setState(() {
      tiles = List<int>.generate(tileCount, (index) => index); // Reset tiles
      emptyTileIndex = tileCount - 1; // Set the last tile as empty
    });
  }

  void _moveTile(int tileIndex) {
    if (_isAdjacent(tileIndex, emptyTileIndex)) {
      setState(() {
        // Swap the selected tile with the empty tile
        tiles[emptyTileIndex] = tiles[tileIndex];
        tiles[tileIndex] = tileCount - 1; // Mark as empty
        emptyTileIndex = tileIndex; // Update empty tile index
      });
      if (_isPuzzleSolved()) {
        // Show dialog if the puzzle is solved
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: "Congratulation!",
          text: 'You finished the puzzle',
          confirmBtnColor: Colors.greenAccent.shade700,
          onConfirmBtnTap: () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) => Games()));
          },
        );
      }
    }
  }

  bool _isAdjacent(int tileIndex, int emptyIndex) {
    int tileRow = tileIndex ~/ gridSize;
    int tileCol = tileIndex % gridSize;
    int emptyRow = emptyIndex ~/ gridSize;
    int emptyCol = emptyIndex % gridSize;

    // Check if tile is adjacent to the empty tile
    return (tileRow == emptyRow && (tileCol - emptyCol).abs() == 1) ||
        (tileCol == emptyCol && (tileRow - emptyRow).abs() == 1);
  }

  bool _isPuzzleSolved() {
    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i] != i) return false; // Check order
    }
    return true;
  }

  Widget _buildTile(int tileIndex) {
    if (tiles[tileIndex] == tileCount - 1) {
      return SizedBox.shrink(); // Empty tile
    }

    // Set the image asset path based on tile index
    if (widget.difficulty == "Hard") {
      String imageAsset =
          'assets/insideApp/games/sliding puzzle/HARD/$randomItem${tiles[tileIndex] + 1}.png';
      return GestureDetector(
        onTap: () => _moveTile(tileIndex), // Move tile when tapped
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.1), // Shadow color with opacity
                  spreadRadius: 1, // Spread of the shadow
                  blurRadius: 2, // Blur effect for the shadow
                  offset: Offset(0, 4), // Position of the shadow (x, y)
                ),
              ],
              image: DecorationImage(
                image: AssetImage(imageAsset),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10)),
        ),
      );
    } else if (widget.difficulty == "Normal") {
      String imageAsset =
          'assets/insideApp/games/sliding puzzle/NORMAL/$randomItem${tiles[tileIndex] + 1}.png';
      return GestureDetector(
        onTap: () => _moveTile(tileIndex), // Move tile when tapped
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1.0),
            image: DecorationImage(
              image: AssetImage(imageAsset),
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } else {
      String imageAsset =
          'assets/insideApp/games/sliding puzzle/EASY/$randomItem${tiles[tileIndex] + 1}.png';
      return GestureDetector(
        onTap: () => _moveTile(tileIndex), // Move tile when tapped
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1.0),
            image: DecorationImage(
              image: AssetImage(imageAsset),
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _showSolvedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You solved the puzzle!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => Games())); // Close dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  var gameInstruction = [
    {
      'title': 'Goal',
      'text':
          'Put the picture back together! The image at the top shows what the puzzle should look like when it’s completed.',
    },
    {
      'title': 'Moving Pieces',
      'text':
          "Tap on a piece that’s next to an empty spot to slide it over. Keep sliding pieces to arrange them in the right order.",
    },
    {
      'title': 'Shuffle Button',
      'text':
          "If you want to mix up the puzzle pieces again or can't solve the puzzle, tap the button in the bottom right corner.",
    },
    {
      'title': 'Have Fun!',
      'text':
          "Keep moving pieces until the picture looks like the one above. Then you win!",
    },
  ];
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < gameInstruction.length) {
      _controller.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _controller.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void loadInstructions() {
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
                return SingleChildScrollView(
                  child: SizedBox(
                    height: 350,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView(
                            controller: _controller,
                            onPageChanged: (index) {
                              setDialogState(() {
                                _currentPage = index;
                              });
                            },
                            children: [
                              ...List.generate(gameInstruction.length, (index) {
                                return Column(
                                  // Align content to the start
                                  children: [
                                    Text(
                                      gameInstruction[index]['title']!,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 23,
                                      ),
                                    ),
                                    Gap(20),
                                    Image.asset(
                                      'assets/insideApp/games/sliding puzzle/puzzle${index + 1}.png',
                                      width:
                                          200, // Adjust image size to fit better
                                      height: 100,
                                      fit: BoxFit.fill,
                                    ),
                                    Gap(20),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        gameInstruction[index]['text']!,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              // WordSearchTip1(),
                              // WordSearchTip2(),
                              // WordSearchTip3(),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed:
                                  _currentPage > 0 ? _previousPage : null,
                              icon: Icon(Icons.arrow_back),
                              color:
                                  _currentPage > 0 ? Colors.blue : Colors.grey,
                            ),
                            Text(' ${_currentPage + 1}'),
                            IconButton(
                              onPressed: _currentPage < gameInstruction.length
                                  ? _nextPage
                                  : null,
                              icon: Icon(Icons.arrow_forward),
                              color: _currentPage < gameInstruction.length - 1
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    ).then((_) {
      // Reset the current page to 0 when the dialog is closed
      setState(() {
        _currentPage = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) => Games()));
          },
          icon: Image.asset(
              height: MediaQuery.of(context).size.height * 0.045,
              "assets/insideApp/close.png"),
        ),
        actions: [
          IconButton(
            onPressed: () {
              loadInstructions();
            },
            icon: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(
                    height: MediaQuery.of(context).size.height * 0.05,
                    "assets/insideApp/games/instruction.png"),
              ),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/insideApp/games/puzzle game.png"),
                fit: BoxFit
                    .fill, // Keep the image covering the entire background
              ),
            ),
            child: SizedBox(),
          ),
          Positioned(
            top: 70,
            child: Container(
              margin: EdgeInsets.only(bottom: 16.0),
              height: 180, // Adjust height as needed
              width: 180,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.2), // Shadow color with opacity
                    spreadRadius: 5, // Spread of the shadow
                    blurRadius: 10, // Blur effect for the shadow
                    offset: Offset(0, 4), // Position of the shadow (x, y)
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(
                    fullImageAsset,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          // GridView for the puzzle tiles
          Positioned(
            top: MediaQuery.of(context).size.height * .38,
            child: Container(
              width: MediaQuery.of(context).size.width *
                  .80, // Set the width directly
              height: MediaQuery.of(context).size.width *
                  .80, // Set the height directly
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.2), // Shadow color with opacity
                    spreadRadius: 5, // Spread of the shadow
                    blurRadius: 10, // Blur effect for the shadow
                    offset: Offset(0, 4), // Position of the shadow (x, y)
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridSize, // Dynamic grid size
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  ),
                  itemCount: tileCount, // Total tiles based on grid size
                  itemBuilder: (context, index) {
                    return _buildTile(index);
                  },
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16.0,
            right: 20.0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: IconButton(
                onPressed: _initializePuzzle, // Shuffle and restart the puzzle
                icon: Icon(Icons.shuffle),
                color: Colors.black,
              ),
            ),
          ),
          // Positioned(
          //   bottom: 16.0,
          //   right: 20.0,
          //   child: Container(
          //     decoration: BoxDecoration(
          //         color: Colors.white, borderRadius: BorderRadius.circular(10)),
          //     child: IconButton(
          //       onPressed: () {}, // Shuffle and restart the puzzle
          //       icon: Icon(Icons.lightbulb),
          //       color: Colors.black,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
