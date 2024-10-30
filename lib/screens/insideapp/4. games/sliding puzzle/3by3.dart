import 'package:flutter/material.dart';

class Puzzle3 extends StatefulWidget {
  @override
  _Puzzle3State createState() => _Puzzle3State();
}

class _Puzzle3State extends State<Puzzle3> {
  late List<int> tiles;
  int emptyTileIndex = 8; // Index of the empty tile
  final int gridSize = 3; // 3x3 grid

  @override
  void initState() {
    super.initState();
    _initializePuzzle(); // Shuffle the puzzle at the start
  }

  void _initializePuzzle() {
    tiles = List<int>.generate(9, (index) => index); // Tiles from 0 to 8
    tiles.shuffle(); // Shuffle the tiles
    emptyTileIndex = tiles.indexOf(8); // Find the empty tile index
    setState(() {});
  }

  void _solvePuzzle() {
    setState(() {
      tiles = List<int>.generate(9, (index) => index); // Tiles from 0 to 8
      emptyTileIndex = 8; // The last tile is empty
    });
  }

  void _moveTile(int tileIndex) {
    if (_isAdjacent(tileIndex, emptyTileIndex)) {
      setState(() {
        // Swap the selected tile with the empty tile
        tiles[emptyTileIndex] = tiles[tileIndex];
        tiles[tileIndex] = 8; // Mark the moved tile position as empty
        emptyTileIndex = tileIndex; // Update the empty tile index
      });

      // Check if the puzzle is solved after moving a tile
      if (_isPuzzleSolved()) {
        _showSolvedDialog(); // Show dialog when the puzzle is solved
      }
    }
  }

  bool _isAdjacent(int tileIndex, int emptyIndex) {
    int tileRow = tileIndex ~/ gridSize;
    int tileCol = tileIndex % gridSize;
    int emptyRow = emptyIndex ~/ gridSize;
    int emptyCol = emptyIndex % gridSize;

    // Check if the tile is horizontally or vertically adjacent to the empty tile
    return (tileRow == emptyRow && (tileCol - emptyCol).abs() == 1) ||
        (tileCol == emptyCol && (tileRow - emptyRow).abs() == 1);
  }

  bool _isPuzzleSolved() {
    // Check if the tiles are in order from 0 to 7, and 8 is the empty tile
    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i] != i) {
        return false; // If any tile is out of order, return false
      }
    }
    return true; // If all tiles are in order, return true
  }

  Widget _buildTile(int tileIndex) {
    if (tiles[tileIndex] == 8) {
      return SizedBox.shrink(); // Empty tile
    }

    // Set the image asset path based on the tile index
    String imageAsset =
        'assets/insideApp/games/sliding puzzle/3by3/b${tiles[tileIndex]}.png';

    return GestureDetector(
      onTap: () => _moveTile(tileIndex), // Move the tile when tapped
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1.0),
          image: DecorationImage(
            image: AssetImage(imageAsset),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
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
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Full image asset path
    String fullImageAsset =
        'assets/insideApp/games/sliding puzzle/3by3/b.png'; // Replace with your full image path

    return Scaffold(
      appBar: AppBar(
        title: Text('Image Sliding Puzzle'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _solvePuzzle, // Solve the puzzle
            tooltip: 'Solve Puzzle',
          ),
          IconButton(
            onPressed: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (_) => twoBlocks(),
              //   ),
              // );
            },
            icon: Icon(Icons.next_plan_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Container for the whole image
            Container(
              margin: EdgeInsets.only(bottom: 16.0),
              height: 150, // Adjust the height as needed
              width: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(fullImageAsset),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            // GridView for the puzzle
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize, // 3x3 grid
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ),
                itemCount: 9, // Total tiles for a 3x3 grid
                itemBuilder: (context, index) {
                  return _buildTile(index);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _initializePuzzle, // Shuffle and restart the puzzle
        child: Icon(Icons.refresh),
      ),
    );
  }
}
