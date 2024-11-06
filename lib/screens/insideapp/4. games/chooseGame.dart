import 'package:flutter/material.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/memory%20game/memory_game.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/game2.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/level_selection.dart';
import 'package:test_drawing/screens/insideapp/home.dart';

class Games extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          centerTitle: true,
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of items in each row
            crossAxisSpacing: 20, // Spacing between columns
            mainAxisSpacing: 20, // Spacing between rows
          ),
          itemCount: 6, // Total number of images
          itemBuilder: (context, index) {
            // Define each image and its tap event
            switch (index) {
              case 0:
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SelectDifficulty(game: 'object_odyssey'),
                      ),
                    );
                  },
                  child:
                      Image.asset('assets/insideApp/games/object_odyssey.png'),
                );
              case 1:
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SelectDifficulty(game: 'pictoword'),
                      ),
                    );
                  },
                  child: Image.asset('assets/insideApp/games/pictoword.png'),
                );
              case 2:
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SelectDifficulty(game: 'memory_game'),
                      ),
                    );
                  },
                  child: Image.asset('assets/insideApp/games/memory_game.png'),
                );
              case 3:
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SelectDifficulty(game: 'sliding_game'),
                      ),
                    );
                  },
                  child: Image.asset('assets/insideApp/games/sliding_game.png'),
                );
              case 4:
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectDifficulty(game: 'letter_search'),));
                  },
                  child: Image.asset('assets/insideApp/games/memory_game.png'),
                );
              case 5:
                return InkWell(
                  onTap: () {},
                  child: Image.asset('assets/insideApp/games/memory_game.png'),
                );
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }
}
