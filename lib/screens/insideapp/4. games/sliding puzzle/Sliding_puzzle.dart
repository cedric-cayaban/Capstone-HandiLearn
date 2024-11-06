import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    // Set the grid size and tile count based on difficulty
    gridSize = widget.difficulty == 'Easy'
        ? 2
        : widget.difficulty == 'Normal'
            ? 3
            : 3;
    tileCount = gridSize * gridSize;
    if (widget.difficulty == 'Easy') {
      fullImageAsset = 'assets/insideApp/games/sliding puzzle/2by2/b.png';
    } else if (widget.difficulty == 'Normal') {
      fullImageAsset = 'assets/insideApp/games/sliding puzzle/3by3/b.png';
    } else {
      fullImageAsset = 'assets/insideApp/games/sliding puzzle/4by4/b.png';
    }

    _initializePuzzle();
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
        _showSolvedDialog(); // Show dialog if the puzzle is solved
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
          'assets/insideApp/games/sliding puzzle/4by4/b${tiles[tileIndex]}.png';
      return GestureDetector(
        onTap: () => _moveTile(tileIndex), // Move tile when tapped
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
    } else {
      String imageAsset =
          'assets/insideApp/games/sliding puzzle/${gridSize}by${gridSize}/b${tiles[tileIndex]}.png';
      return GestureDetector(
        onTap: () => _moveTile(tileIndex), // Move tile when tapped
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
                Navigator.of(context).pop(); // Close dialog
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Sliding Puzzle'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _solvePuzzle, // Solve the puzzle
            tooltip: 'Solve Puzzle',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Container for the full image preview
            Container(
              margin: EdgeInsets.only(bottom: 16.0),
              height: 150, // Adjust height as needed
              width: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(fullImageAsset),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            // GridView for the puzzle tiles
            Expanded(
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
