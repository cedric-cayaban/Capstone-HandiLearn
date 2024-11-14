import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:test_drawing/objects/crossword.dart';
import 'package:test_drawing/screens/1).%20insideapp/4.%20games/game_selection.dart';
import 'package:test_drawing/screens/1).%20insideapp/4.%20games/instructions/word_search.dart';
import 'package:word_search_safety/word_search_safety.dart'; // Import the word_search_safety package

class WordSearchHard extends StatefulWidget {
  const WordSearchHard({Key? key}) : super(key: key);

  @override
  _WordSearchHardState createState() => _WordSearchHardState();
}

class _WordSearchHardState extends State<WordSearchHard> {
  final int numBoxPerRow = 6;
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

  //COPY DITO

  final PageController _controller = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
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
            title: Center(child: Text('How to play')),
            backgroundColor: Colors.white,
            contentPadding: EdgeInsets.all(16),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setDialogState) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
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
                            WordSearchTip1(),
                            WordSearchTip2(),
                            WordSearchTip3(),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: _currentPage > 0 ? _previousPage : null,
                            icon: Icon(Icons.arrow_back),
                            color: _currentPage > 0 ? Colors.blue : Colors.grey,
                          ),
                          Text(' ${_currentPage + 1}'),
                          IconButton(
                            onPressed: _currentPage < 2 ? _nextPage : null,
                            icon: Icon(Icons.arrow_forward),
                            color: _currentPage < 2 ? Colors.blue : Colors.grey,
                          ),
                        ],
                      ),
                    ],
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

  //COPY DITO

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

            // INSTRUCTION BUTTON
            Positioned(
              top: 20,
              right: 10,
              child: GestureDetector(
                onTap: loadInstructions,
                child: CircleAvatar(
                  radius: 26, // Adjust size to match the image’s
                  backgroundColor: Colors.white,

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/insideApp/games/instruction.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
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
                  //color: Colors.black45,
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Center(child: drawAnswerList())),
            ),
          ],
        ),
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

  void onDragUpdate(PointerMoveEvent event) {
    // This method is now only responsible for drawing the line and updating the drag position
    generateLineOnDrag(event);
  }

  void onDragEnd([PointerUpEvent? event]) {
    print("PointerUpEvent");
    if (currentDragObj.value.currentDragLine.isEmpty) return;

    // Check if the drawn line matches any of the answers
    int indexFound = answerList.value.indexWhere((answer) {
      return answer.answerLines.join("-") ==
          currentDragObj.value.currentDragLine.join("-");
    });

    if (indexFound >= 0) {
      // Mark the word as found
      setState(() {
        answerList.value[indexFound].done = true;
        charsDone.value.addAll(answerList.value[indexFound].answerLines);
      });

      // Update the UI by notifying listeners
      charsDone.notifyListeners();
      answerList.notifyListeners();

      // Check if all words are found
      if (answerList.value.every((answer) => answer.done)) {
        // Show the loadFinishModal dialog if all words are found
        loadFinishModal();
      }
    }

    // Reset the drag line after checking
    currentDragObj.value.currentDragLine.clear();
    currentDragObj.notifyListeners();
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

  void generateRandomWord() {
    final List<String> wl = [
      'PENCIL',
      'APPLE',
      'AT',
      'ORANGE',
      'DOG',
      'KITE',
      'ON'
    ];

    // Shuffle the list and take 6 random words
    wl.shuffle(Random());
    final List<String> randomWords = wl.take(6).toList();

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
    return Wrap(
      spacing: 8.0, // Horizontal space between words
      runSpacing: 8.0, // Vertical space between rows
      alignment: WrapAlignment.center, // Center the words
      children: List.generate(answerList.value.length, (index) {
        bool isFound = answerList.value[index].done;
        return Container(
          height: MediaQuery.of(context).size.height * 0.06,
          width: MediaQuery.of(context).size.width * 0.28,
          decoration: BoxDecoration(
            color: Colors.black45,
            border: Border.all(
              color: Colors.white, // Change this to your preferred border color
              width: 1.5, // Set the border width
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Center(
            child: Text(
              answerList.value[index].answer,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.width * 0.055,
                decoration: isFound ? TextDecoration.lineThrough : null,
                decorationColor: Colors.white, // Line-through color
                decorationThickness: 3.0, // Adjust line thickness
              ),
            ),
          ),
        );
      }),
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
