import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:test_drawing/objects/crossword.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/game_selection.dart';
import 'package:word_search_safety/word_search_safety.dart'; // Import the word_search_safety package

class WordSearchMedium extends StatefulWidget {
  const WordSearchMedium({Key? key}) : super(key: key);

  @override
  _WordSearchMediumState createState() => _WordSearchMediumState();
}

class _WordSearchMediumState extends State<WordSearchMedium> {
  final int numBoxPerRow = 5;
  final double padding = 5.0;
  late Size sizeBox;

  ValueNotifier<List<List<String>>> listChars =
      ValueNotifier<List<List<String>>>([]);
  ValueNotifier<List<CrosswordAnswer>> answerList =
      ValueNotifier<List<CrosswordAnswer>>([]);
  ValueNotifier<CurrentDragObj> currentDragObj =
      ValueNotifier<CurrentDragObj>(CurrentDragObj());
  ValueNotifier<List<int>> charsDone = ValueNotifier<List<int>>([]);

  @override
  void initState() {
    super.initState();
    generateRandomWord();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/insideApp/games/word search/background.png'), // Replace with your background image path
            fit: BoxFit.cover, // Ensures the image covers the entire background
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 20,
              left: 10,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Games(),
                    ));
                  },
                  icon: const Icon(
                    color: Colors.black,
                    Icons.arrow_back,
                    size: 30,
                  )),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.04,
              child:
                  Image.asset('assets/insideApp/games/word search/header.png'),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: size.height *
                    0.45, // Set the height to 45% of screen height
                padding: EdgeInsets.all(padding),
                // margin: EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/insideApp/games/word search/board.png'), // Your board image path
                    fit: BoxFit.cover,
                  ),
                  // color: Colors.blue.withOpacity(0.3), // Optional overlay color

                  borderRadius:
                      BorderRadius.circular(8.0), // Optional rounded corners
                ),
                child: drawCrosswordBox(),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.6,
              child:
                  Image.asset('assets/insideApp/games/word search/footer.png'),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.78,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.12,
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(
                      12.0), // Adjust the radius as needed
                ),
                child: Center(child: drawAnswerList()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onDragUpdate(PointerMoveEvent event) {
    // This method is now only responsible for drawing the line and updating the drag position
    generateLineOnDrag(event);
  }

  void onDragEnd([PointerUpEvent? event]) {
    print("PointerUpEvent");

    if (currentDragObj.value.currentDragLine.isEmpty) return;

    // Find index of matching answer in answerList
    int indexFound = answerList.value.indexWhere((answer) =>
        answer.answerLines.join("-") ==
        currentDragObj.value.currentDragLine.join("-"));

    if (indexFound >= 0) {
      // If match found, mark the word as done
      setState(() {
        answerList.value[indexFound].done = true;
        charsDone.value.addAll(answerList.value[indexFound].answerLines);
      });

      // Notify listeners to update UI
      charsDone.notifyListeners();
      answerList.notifyListeners();

      // Check if all words have been found
      bool allWordsFound = answerList.value.every((answer) => answer.done);
      if (allWordsFound) {
        // Show finish modal if all words are found
        loadFinishModal();
      }
    }

    // Clear the current drag line after processing
    currentDragObj.value.currentDragLine.clear();
    currentDragObj.notifyListeners();
  }

// Show finish modal dialog function
  void _showFinishModal() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: "Congratulation!",
      text: 'You find all the letters',
      onConfirmBtnTap: () {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => Games()));
      },
    );
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Text("Congratulations!"),
    //       content: Text("You've found all the words."),
    //       actions: <Widget>[
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //             // Optional: Reset the game or start a new level here if desired
    //           },
    //           child: Text("OK"),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  int calculateIndexBasePosLocal(Offset localPosition) {
    double maxSizeBox =
        (sizeBox.width - (numBoxPerRow - 1) * padding) / numBoxPerRow;
    if (localPosition.dy > sizeBox.width || localPosition.dx > sizeBox.width)
      return -1;

    int x = 0, y = 0;
    double yAxis = 0, xAxis = 0;

    for (var i = 0; i < numBoxPerRow; i++) {
      xAxis += maxSizeBox +
          (i == 0 || i == (numBoxPerRow - 1) ? padding / 2 : padding);
      if (xAxis > localPosition.dx) {
        x = i;
        break;
      }
    }

    for (var i = 0; i < numBoxPerRow; i++) {
      yAxis += maxSizeBox +
          (i == 0 || i == (numBoxPerRow - 1) ? padding / 2 : padding);
      if (yAxis > localPosition.dy) {
        y = i;
        break;
      }
    }

    return y * numBoxPerRow + x;
  }

  void generateLineOnDrag(PointerMoveEvent event) {
    if (currentDragObj.value.currentDragLine.isEmpty) {
      currentDragObj.value.currentDragLine = [];
    }

    int indexBase = calculateIndexBasePosLocal(event.localPosition);

    if (indexBase >= 0) {
      if (currentDragObj.value.currentDragLine.length >= 2) {
        WSOrientation? wsOrientation;

        if (currentDragObj.value.currentDragLine[0] % numBoxPerRow ==
            currentDragObj.value.currentDragLine[1] % numBoxPerRow)
          wsOrientation = WSOrientation.vertical;
        else if (currentDragObj.value.currentDragLine[0] ~/ numBoxPerRow ==
            currentDragObj.value.currentDragLine[1] ~/ numBoxPerRow)
          wsOrientation = WSOrientation.horizontal;

        if (wsOrientation == WSOrientation.horizontal &&
            indexBase ~/ numBoxPerRow !=
                currentDragObj.value.currentDragLine[1] ~/ numBoxPerRow) {
          onDragEnd(); // No event passed
        } else if (wsOrientation == WSOrientation.vertical &&
            indexBase % numBoxPerRow !=
                currentDragObj.value.currentDragLine[1] % numBoxPerRow) {
          onDragEnd(); // No event passed
        }
      }

      if (!currentDragObj.value.currentDragLine.contains(indexBase)) {
        currentDragObj.value.currentDragLine.add(indexBase);
      } else if (currentDragObj.value.currentDragLine.length >= 2 &&
          currentDragObj.value.currentDragLine[
                  currentDragObj.value.currentDragLine.length - 2] ==
              indexBase) {
        onDragEnd(); // No event passed
      }
    }
    currentDragObj.notifyListeners();
  }

  void onDragStart(int indexArray) {
    try {
      List<CrosswordAnswer> indexSelecteds = answerList.value
          .where((answer) => answer.indexArray == indexArray)
          .toList();
      if (indexSelecteds.isEmpty) return;
      currentDragObj.value.indexArrayOnTouch = indexArray;
      currentDragObj.notifyListeners();
    } catch (e) {
      print("Error in onDragStart: $e");
    }
  }

  Widget drawCrosswordBox() {
    return Listener(
      onPointerUp: (event) => onDragEnd(event),
      onPointerMove: (event) => onDragUpdate(event),
      child: LayoutBuilder(
        builder: (context, constraints) {
          sizeBox = Size(constraints.maxWidth, constraints.maxWidth);
          return SizedBox(
            height: sizeBox.height,
            width: sizeBox.width,
            child: GridView.builder(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.01),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: numBoxPerRow,
                crossAxisSpacing: padding, // Remove spacing
                mainAxisSpacing: padding, // Remove spacing
                childAspectRatio: 1,
              ),
              itemCount: numBoxPerRow * numBoxPerRow,
              physics: ScrollPhysics(),
              itemBuilder: (context, index) {
                String char = listChars.value.expand((e) => e).toList()[index];
                return Material(
                  color: Colors
                      .transparent, // Transparent to not cover content with color
                  child: Listener(
                    onPointerDown: (event) => onDragStart(index),
                    child: ValueListenableBuilder(
                      valueListenable: currentDragObj,
                      builder: (context, CurrentDragObj value, child) {
                        // Use an AnimatedContainer for smooth color transition
                        Color color = Colors.white;

                        if (value.currentDragLine.contains(index)) {
                          color = Colors.yellow; // Color when actively dragging
                        } else if (charsDone.value.contains(index)) {
                          color = Colors.green; // Color when word is found
                        }

                        return AnimatedContainer(
                          duration: Duration(
                              milliseconds:
                                  100), // Adjust duration for smoothness
                          curve: Curves.easeInOut, // Use a smooth curve
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            char.toUpperCase(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: color == Colors.green
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void loadFinishModal() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: "Congratulation!",
      text: 'You find all the words',
      onConfirmBtnTap: () {
        Navigator.of(context).pop();
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => Games()));
      },
    );
    // showDialog(
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     backgroundColor: Colors.white,
    //     content: Container(
    //       color: Colors.white,
    //       height: MediaQuery.of(context).size.height * 0.45,
    //       width: MediaQuery.of(context).size.width * 0.8,
    //       child: SingleChildScrollView(
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             const Text(
    //               "Congratulations!",
    //               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    //             ),
    //             const SizedBox(height: 5),
    //             const Text("You found all the words!",
    //                 style: TextStyle(fontSize: 19)),
    //             const SizedBox(height: 20),
    //             Image.asset(
    //                 height: MediaQuery.of(context).size.height * 0.25,
    //                 'assets/insideApp/learnWriting/components/dancing.gif'),
    //             const SizedBox(height: 20),
    //             GestureDetector(
    //               onTap: () {
    //                 Navigator.of(context).pop();
    //                 Navigator.of(context).pushReplacement(MaterialPageRoute(
    //                   builder: (context) => Games(),
    //                 ));
    //               },
    //               child: Image.asset(
    //                   height: 70,
    //                   width: 70,
    //                   'assets/insideApp/learnWriting/components/arrow-forward.png'),
    //             )
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  void generateRandomWord() {
    final List<String> wl = ['CAT', 'KITE', 'PIG', 'AT', 'ON', 'BAG'];

    // Shuffle the list and take 5 random words
    wl.shuffle(Random());
    final List<String> randomWords = wl.take(5).toList();

    final WSSettings ws = WSSettings(
      width: numBoxPerRow,
      height: numBoxPerRow,
      orientations: [
        WSOrientation.horizontal,
        WSOrientation.vertical,
      ],
    );

    final WordSearchSafety wordSearch = WordSearchSafety();
    final WSNewPuzzle newPuzzle = wordSearch.newPuzzle(randomWords, ws);

    if (newPuzzle.errors!.isEmpty) {
      listChars.value = newPuzzle.puzzle ?? [];

      final WSSolved solved =
          wordSearch.solvePuzzle(newPuzzle.puzzle ?? [], randomWords);

      answerList.value = solved.found!.map((solve) {
        // Ensure the word fits within the grid by checking for boundaries
        return CrosswordAnswer(
          answer: solve.word,
          answerLines: List.generate(solve.word.length, (index) {
            // Check if the word is horizontal or vertical, and adjust coordinates
            if (solve.orientation == WSOrientation.horizontal) {
              // Horizontal words
              return solve.y * numBoxPerRow + (solve.x + index);
            } else if (solve.orientation == WSOrientation.vertical) {
              // Vertical words
              return (solve.y + index) * numBoxPerRow + solve.x;
            } else {
              // In case there's a diagonal (which shouldn't be the case now)
              return -1;
            }
          }),
          indexArray: solved.found!.indexOf(solve),
        );
      }).toList();
    } else {
      newPuzzle.errors?.forEach((error) {
        print("Error: $error");
      });
    }
  }

  Widget drawAnswerList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Top row with three words
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(3, (index) {
            bool isFound = answerList.value[index].done;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                answerList.value[index].answer,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                  decoration: isFound ? TextDecoration.lineThrough : null,
                  decorationColor: Colors.white, // Line-through color
                  decorationThickness: 2.0, // Adjust line thickness
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 8.0), // Space between the two rows

        // Bottom row with two words
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(2, (index) {
            bool isFound = answerList.value[index + 3].done;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                answerList.value[index + 3].answer,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                  decoration: isFound ? TextDecoration.lineThrough : null,
                  decorationColor: Colors.white, // Line-through color
                  decorationThickness: 2.0, // Adjust line thickness
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// class CrosswordAnswer {
//   String answer;
//   List<int> answerLines;
//   bool done;
//   int indexArray;

//   CrosswordAnswer({
//     required this.answer,
//     required this.answerLines,
//     this.done = false,
//     required this.indexArray,
//   });
// }

// class CurrentDragObj {
//   List<int> currentDragLine = [];
//   int indexArrayOnTouch = -1;

//   void notifyListeners() {}
// }
