import 'package:flutter/material.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/sliding%20puzzle/2by2.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/sliding%20puzzle/3by3.dart';
// 3x3 puzzle

class LevelSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Puzzle Level'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => Puzzle2(), // Navigate to 2x2 puzzle
                  ),
                );
              },
              child: Text('2x2 Puzzle'),
            ),
            SizedBox(height: 20), // Spacer between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => Puzzle3(), // Navigate to 3x3 puzzle
                  ),
                );
              },
              child: Text('3x3 Puzzle'),
            ),
          ],
        ),
      ),
    );
  }
}
