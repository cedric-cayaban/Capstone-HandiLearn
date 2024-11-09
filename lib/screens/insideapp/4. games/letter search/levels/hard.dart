import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/game_selection.dart';

class LetterSearchHard extends StatefulWidget {
  const LetterSearchHard({super.key});

  @override
  State<LetterSearchHard> createState() => _LetterSearchHardState();
}

class _LetterSearchHardState extends State<LetterSearchHard> {
  @override
  void initState() {
    super.initState();
    selectedLetters = (findLetters..shuffle()).take(7).toList();
    correctLetters = selectedLetters.sublist(0, 5); // Select first 5 as correct
  }

  List<String> findLetters = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  late List<String> selectedLetters;
  late List<String> correctLetters;
  int currentTargetIndex = 0;
  bool showCheckmark = false;

  // void dispose() {
  //   // Reset the orientation to the default system orientation (or another specific one)
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ]);
  //   super.dispose();
  // }

  void loadFinishModal() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        content: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.4,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Congratulations!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text("You found all the letters!",
                    style: TextStyle(fontSize: 19)),
                const SizedBox(height: 20),
                Image.asset(
                    height: MediaQuery.of(context).size.height * 0.25,
                    'assets/insideApp/learnWriting/components/dancing.gif'),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Games(),
                    ));
                  },
                  child: Image.asset(
                      height: 70,
                      width: 70,
                      'assets/insideApp/learnWriting/components/arrow-forward.png'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onLetterTap(String tappedLetter) {
    if (tappedLetter == correctLetters[currentTargetIndex]) {
      setState(() {
        currentTargetIndex++;
        showCheckmark = true;
      });

      // Hide the checkmark after 1 second
      Timer(const Duration(seconds: 1), () {
        setState(() {
          showCheckmark = false;
        });
      });

      // Check if all letters have been found
      if (currentTargetIndex >= correctLetters.length) {
        loadFinishModal();
      }
    } else {
      print("Incorrect letter. Try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Offset> positions = [
      Offset(
        MediaQuery.of(context).size.height * 0.35,
        MediaQuery.of(context).size.width * 0.17,
      ),
      Offset(
        MediaQuery.of(context).size.height * 0.73,
        MediaQuery.of(context).size.width * 0.55,
      ),
      Offset(
        MediaQuery.of(context).size.height * 0.7,
        MediaQuery.of(context).size.width * 0.1,
      ),
      Offset(
        MediaQuery.of(context).size.height * 0.5,
        MediaQuery.of(context).size.width * 0.34,
      ),
      Offset(
        MediaQuery.of(context).size.height * 0.4,
        MediaQuery.of(context).size.width * 0.6,
      ),
      Offset(
        MediaQuery.of(context).size.height * 0.65,
        MediaQuery.of(context).size.width * 0.7,
      ),
      Offset(
        MediaQuery.of(context).size.height * 0.35,
        MediaQuery.of(context).size.width * 0.88,
      ),
    ];

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/insideApp/games/letter search/hard.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            //BACK
            Positioned(
              top: 20,
              left: 20,
              child: IconButton(
                  onPressed: () {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitDown,
                      DeviceOrientation.portraitUp,
                    ]);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Games(),
                    ));
                  },
                  icon: const Icon(
                    color: Colors.white,
                    Icons.arrow_back,
                    size: 30,
                  )),
            ),
            // LETTER TO FIND
            Positioned(
              top: 20,
              child: Card(
                color: Colors.black54,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    currentTargetIndex < correctLetters.length
                        ? 'Letter to find: ${correctLetters[currentTargetIndex]}'
                        : 'All letters found!',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // Found letters in a card
            Positioned(
              top: 20,
              right: 20,
              child: Card(
                color: Colors.black54,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${currentTargetIndex} / 5',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // Letters to find
            for (int a = 0; a < selectedLetters.length; a++)
              Positioned(
                top: positions[a].dx,
                left: positions[a].dy,
                child: GestureDetector(
                  onTap: () => onLetterTap(selectedLetters[a]),
                  child: Image.asset(
                    height: 60,
                    width: 60,
                    'assets/insideApp/games/letter search/${selectedLetters[a]}.png',
                  ),
                ),
              ),
            // Checkmark overlay with smooth transition
            AnimatedOpacity(
              opacity: showCheckmark ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(20),
                child: const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 60,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
