import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:test_drawing/data/userAccount.dart';
import 'package:test_drawing/objects/lesson.dart';
import 'package:test_drawing/provider/lesson_provider.dart';
import 'package:test_drawing/screens/1).%20insideapp/1.%20learn/reading/character_selection.dart';
import 'package:flutter/animation.dart';

class SelectedItem extends StatefulWidget {
  SelectedItem({
    super.key,
    required this.lesson,
    required this.forNextLesson,
    required this.index,
    required this.characterDone,
    required this.lessonField,
  });

  final Lesson lesson;
  List<Lesson> forNextLesson;
  final int index;
  final int characterDone;
  final String lessonField;

  @override
  State<SelectedItem> createState() => _SelectedItemState();
}

class _SelectedItemState extends State<SelectedItem>
    with SingleTickerProviderStateMixin {
  stt.SpeechToText _speech = stt.SpeechToText();

  bool _isListening = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isFinished = false;

  Timer? _listeningTimer;

  late int updatedCharacterDone = widget.characterDone;

  bool _dialogShown = false; // Add this variable

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    print(widget.lesson.character);
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    sayTheSound();
    initSpeechState();
  }

  void initSpeechState() async {
    bool available = await _speech.initialize();
    if (!mounted) return;
  }

  void updateLesson(LessonProvider provider) async {
    print("updateLesson");
    await provider.updateLesson(widget.lessonField, widget.characterDone);
    provider.updateDialogStatus(false); // Reset dialog status
  }

  void _startListening() {
    final lessonProvider = Provider.of<LessonProvider>(context, listen: false);
    print('Starting to listen');
    _speech.listen(
      listenFor: Duration(seconds: 3),
      onResult: (result) {
        if (result.finalResult) {
          String resultNumber = "";
          print(result.recognizedWords.toLowerCase());
          print(widget.lesson.type);
          print(widget.lesson.character.toLowerCase());
          if (widget.lesson.type == "number") {
            resultNumber =
                convertNumberToWord(widget.lesson.character.toLowerCase());
          }
          if (!_dialogShown) {
            if (widget.lesson.type == "standard" &&
                result.recognizedWords.toLowerCase() ==
                    "letter " + widget.lesson.character.toLowerCase()) {
              print(lessonProvider.ucharacterDone);
              if (widget.index == lessonProvider.ucharacterDone) {
                updateLesson(lessonProvider); // Pass lessonProvider instance
              }
              _dialogShown = true; // Set flag to prevent multiple dialogs
              Navigator.of(context).pop();

              _showSuccessDialog();
            } else if (result.recognizedWords.toLowerCase() ==
                    widget.lesson.character.toLowerCase() &&
                widget.lesson.type == "word") {
              if (widget.index == lessonProvider.ucharacterDone) {
                updateLesson(lessonProvider);
              }
              _dialogShown = true; // Set flag here as well
              Navigator.of(context).pop();

              _showSuccessDialog();
            } else if (result.recognizedWords.toLowerCase() == resultNumber &&
                widget.lesson.type == "number") {
              if (widget.index == lessonProvider.ucharacterDone) {
                updateLesson(lessonProvider);
              }
              _dialogShown = true; // Set flag here as well
              Navigator.of(context).pop();

              _showSuccessDialog();
            } else {
              _dialogShown = true; // Set flag to prevent multiple dialogs
              Navigator.of(context).pop();

              _showFailedDialog();
            }
          }
        }
      },
    );

    setState(() {
      _isListening = true;
    });

    // Start a timer for 2 seconds
    _listeningTimer = Timer(Duration(seconds: 5), () {
      // print('Hindi ka nagsasalita');
      _stopListening(); // Stop listening after 2 seconds
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(); // Close the dialog if it's still open
      }
      _showFailedDialog();
    });
  }

  String convertNumberToWord(String number) {
    final numberWords = {
      '0': 'zero',
      '1': 'one',
      '2': 'two',
      '3': 'three',
      '4': 'four',
      '5': 'five',
      '6': 'six',
      '7': 'seven',
      '8': 'eight',
      '9': 'nine',
    };

    return numberWords[number] ??
        number; // Returns the word or the original character if not a number
  }

  void _stopListening() {
    if (_isListening) {
      _speech.stop();
      _listeningTimer?.cancel(); // Cancel the timer if still active
      setState(() {
        _isListening = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white, // Change to your desired color
          ),
          child: AlertDialog(
            backgroundColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/insideApp/learnReading/read.gif'),
                SizedBox(height: 5),
                Text(
                  'Great Job',
                  style: TextStyle(fontSize: 30),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _dialogShown = false;
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 70,
                            width: 70,
                            child: Image.asset(
                                'assets/insideApp/learnReading/try again.png'),
                          ),
                          Text(
                            'Try Again',
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _dialogShown = false;

                        var nextLesson = widget.forNextLesson[widget.index + 1];
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => SelectedItem(
                            lessonField: widget.lessonField,
                            characterDone: updatedCharacterDone,
                            lesson: nextLesson,
                            index: widget.index + 1,
                            forNextLesson: widget.forNextLesson,
                          ),
                        ));
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 70,
                            width: 70,
                            child: Image.asset(
                                'assets/insideApp/learnReading/next.png'),
                          ),
                          Text(
                            'Next Letter',
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFailedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white, // Change to your desired color
          ),
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/insideApp/learnReading/sorry.gif'),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _dialogShown = false;
                    turnToSpeak();
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 70,
                        width: 70,
                        child: Image.asset(
                            'assets/insideApp/learnReading/try again.png'),
                      ),
                      Text(
                        'Try Again',
                        style: TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void sayTheSound() async {
    try {
      await _audioPlayer.play(
        AssetSource(
            'insideApp/learnReading/audio/${widget.lesson.character}.mp3'),
      );
    } catch (e) {
      print(e);
    }
  }

  void turnToSpeak() {
    _startListening();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white, // Change to your desired color
          ),
          child: AlertDialog(
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      child: Container(
                        height: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                AnimatedBuilder(
                                  animation: _animation,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: _animation.value,
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blueAccent
                                              .withOpacity(0.3),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Icon(
                                  Icons.mic,
                                  size: 40,
                                  color: Colors.blueAccent,
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text("It's your turn to say it")
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    ).then((_) {
      _stopListening(); // Stop listening when the dialog is closed
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final lessonProvider = Provider.of<LessonProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // title: Text("Selected Letter"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/insideApp/learnReading/learnBg.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.35,
              // right: 90,
              child: SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.25, // Change this value to whatever height you need
                width: MediaQuery.of(context).size.height *
                    0.3, // Change this value to whatever width you need
                child: Image.asset(
                  widget.lesson.imgPath, // Using widget.imgPath directly
                  fit: BoxFit
                      .fill, // Optional: to control how the image fits in the box
                ),
              ),
            ),
            Positioned(
              bottom: 160,
              // right: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      // sayTheSound();
                      turnToSpeak();
                    },
                    child: Image.asset(
                        "assets/insideApp/learnReading/Speak Button.png"),
                  ),
                  Gap(30),
                  GestureDetector(
                    onTap: () {
                      sayTheSound();
                    },
                    child: Image.asset(
                        "assets/insideApp/learnReading/Repeat Button.png"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
