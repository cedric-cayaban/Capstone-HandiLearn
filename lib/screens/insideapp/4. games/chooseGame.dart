import 'package:flutter/material.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/game1.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/game2.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/sliding%20puzzle/level_selection.dart';
import 'package:test_drawing/screens/insideapp/home.dart';

class Games extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isTeacher = true;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Home()));
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 30,
            ),
          ),
          // title: Text('Choose Game'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  // Navigate to Screen A
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => QuestionWidget(),
                  //   ),
                  // );
                },
                child: Image.asset('assets/insideApp/games/object_odyssey.png'),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  // Navigate to Screen B
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          QuizScreen(), // Replace with your intended screen
                    ),
                  );
                },
                child: Image.asset('assets/insideApp/games/pictoword.png'),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  // Navigate to Screen B
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Game1(), // Replace with your intended screen
                    ),
                  );
                },
                child: Image.asset('assets/insideApp/games/memory_game.png'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LevelSelectionPage(), // Replace with your intended screen
                    ),
                  );
                },
                child: Text('Puzzle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
