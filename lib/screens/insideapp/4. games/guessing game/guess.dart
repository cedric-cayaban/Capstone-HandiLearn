import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/chooseGame.dart';

class Pictoword extends StatefulWidget {
  Pictoword({required this.difficulty, super.key});

  final String difficulty;

  @override
  _PictowordState createState() => _PictowordState();
}

class _PictowordState extends State<Pictoword> {
  List<String?> blankTiles = [
    null,
    null,
    null,
  ]; // Tracks letters in blank tiles
  late List<String> letters;
  late String correctAnswer = "";
  late int tilesNum = 0;
  late String imagePicto = "";
  Set<String> usedLetters = {};

  @override
  void initState() {
    super.initState();
    if (widget.difficulty == "Easy") {
      correctAnswer = "PIG";
      tilesNum = 3;
      imagePicto = "assets/insideApp/games/2/pig.png";
    } else if (widget.difficulty == "Normal") {
      correctAnswer = "BAG";
      tilesNum = 3;
      imagePicto = "assets/insideApp/games/2/bag.png";
    } else {
      correctAnswer = "BOOK";
      tilesNum = 4;
      imagePicto = "assets/insideApp/games/2/book.png";
    }
    letters = generateRandomLetters().split('');

    print(letters);
  }

  String generateRandomLetters() {
    
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final random = Random();
    String randomLetters =
        correctAnswer; // You can replace this with dynamic random letters generation

    // Generate random letters
    for (int i = 0; i < tilesNum; i++) {
      randomLetters += letters[random.nextInt(letters.length)];
    }

    // Convert the string to a list of characters, shuffle the list, then join it back to a string
    List<String> lettersList = randomLetters.split('');
    lettersList.shuffle(random);

    return lettersList.join(); // Join the shuffled list back into a string
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (_) => Games()));
            },
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/insideApp/games/2/pictoword-bg.png"),
              fit: BoxFit.fill, // Keep the image covering the entire background
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/insideApp/games/2/pictoword-bg.png',
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
              ),
              Positioned(
                top: 50,
                child: Image.asset(
                  imagePicto,
                  height: MediaQuery.of(context).size.height * .48,
                  width: MediaQuery.of(context).size.width * .9,
                  fit: BoxFit.fill,
                ),
              ),
              // Blank Tiles
              Positioned(
                bottom: MediaQuery.of(context).size.height * .32,
                left: 0,
                right: 0, // Ensure you define the left and right if necessary
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(3, (index) => buildBlankTile(index)),
                ),
              ),

              // Letter Options
              Positioned(
                bottom: MediaQuery.of(context).size.height * .07,
                left: 0,
                right: 0, // Ensure you define the left and right if necessary
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: tilesNum == 3 ? 56.0 : 36, vertical: 8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .22,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: tilesNum,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: letters.length,
                      itemBuilder: (context, index) {
                        return buildLetterBox(letters[index]);
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 40,
                child: InkWell(
                  onTap: clearBlankTiles,
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: MediaQuery.of(context).size.width * .30,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Clear',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 40,
                bottom: 10,
                child: InkWell(
                  onTap: () {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.info,
                        text:
                            "It's a portable storage space for your things when you're not at home!");
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: MediaQuery.of(context).size.width * .30,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Hint',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLetterBox(String letter) {
    bool isUsed = usedLetters.contains(letter);
    return GestureDetector(
      onTap: isUsed
          ? null // Disable interaction if the letter is already used
          : () {
              if (blankTiles.contains(null)) {
                placeLetterInBlankTile(letter);
              } else {
                print("All blank tiles are filled. Cannot add more letters.");
              }
            },
      child: Opacity(
        opacity: isUsed ? 0.4 : 1.0, // Lower opacity if used
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Text(
            letter,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }

  Widget buildBlankTile(int index) {
    return GestureDetector(
      onTap: () {
        if (blankTiles[index] != null) {
          returnLetterToBottom(index);
        }
      },
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: blankTiles[index] == null ? Colors.grey[300] : Colors.blue,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Text(
          blankTiles[index] ?? '',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  void placeLetterInBlankTile(String letter) {
    final emptyIndex = blankTiles.indexOf(null);
    if (emptyIndex != -1) {
      setState(() {
        blankTiles[emptyIndex] = letter; // Place letter in blank tile
        usedLetters.add(letter); // Mark letter as used
      });

      if (!blankTiles.contains(null)) {
        if (blankTiles.join() == correctAnswer) {
          print("All tiles filled: ${blankTiles.join()}");

          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'Congratulations',
            text: blankTiles.join(),
            onConfirmBtnTap: () {
              clearBlankTiles();
              Navigator.of(context).pop();
            },
          );
        } else {
          print("All tiles filled: ${blankTiles.join()}");

          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Your answer is incorrect',
            onConfirmBtnTap: () {
              clearBlankTiles();
              Navigator.of(context).pop();
            },
          );
        }
      }
    }
  }

  void returnLetterToBottom(int index) {
    setState(() {
      String? letter = blankTiles[index];
      if (letter != null) {
        // letters.add(letter); // Return the letter to available options
        usedLetters.remove(letter); // Remove from used letters
        blankTiles[index] = null; // Clear the blank tile
      }
    });
  }

  void clearBlankTiles() {
    print(letters);
    print(usedLetters);
    usedLetters.removeAll(letters);
    blankTiles = [null, null, null];
    setState(() {
      // Clear all blank tiles
    });
  }
}
