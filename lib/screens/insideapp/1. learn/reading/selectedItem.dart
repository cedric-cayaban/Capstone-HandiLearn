import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:test_drawing/data/userAccount.dart';
import 'package:test_drawing/objects/lesson.dart';
import 'package:test_drawing/screens/insideapp/1.%20learn/reading/character_selection.dart';

class SelectedItem extends StatefulWidget {
  SelectedItem({
    super.key,
    // required this.imgPath,
    required this.lesson,
    required this.forNextLesson,
    required this.index,
    required this.characterDone,
    required this.lessonField,
  });

  // final String imgPath;
  final Lesson lesson;
  List<Lesson> forNextLesson;
  // final String character;
  final int index;
  final int characterDone;
  final String lessonField;

  @override
  State<SelectedItem> createState() => _SelectedItemState();
}

class _SelectedItemState extends State<SelectedItem> {
  stt.SpeechToText _speech = stt.SpeechToText();

  bool _isListening = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isFinished = false;

  Timer? _listeningTimer;

  late int updatedCharacterDone = widget.characterDone;

  bool _dialogShown = false; // Add this variable

  @override
  void initState() {
    super.initState();
    sayTheSound();
    initSpeechState();
    // print(widget.character);
  }

  void initSpeechState() async {
    bool available = await _speech.initialize();
    if (!mounted) return;
  }

  void updateLesson() async {
    try {
      User user = FirebaseAuth.instance.currentUser!;
      String _uid = user.uid;

      // Assuming 'id' and 'lessonid' are defined elsewhere in your class
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_uid)
          .collection('profiles')
          .doc(id)
          .collection("LessonsFinished")
          .doc(lessonid)
          .update({"${widget.lessonField}": "${widget.characterDone + 1}"});
      updatedCharacterDone = widget.characterDone + 1;
      setState(() {});
    } catch (e) {
      print('Error updating lesson: $e'); // Handle error appropriately
    }
  }

  void _startListening() {
    print('Starting to listen');
    _speech.listen(
      listenFor: Duration(seconds: 3),
      onResult: (result) {
        if (result.finalResult) {
          print(result.recognizedWords.toLowerCase());

          if (!_dialogShown) {
            // Check if a dialog is already shown
            if (widget.lesson.type == "word" &&
                result.recognizedWords.toLowerCase() ==
                    widget.lesson.character.toLowerCase()) {
              if (widget.index == widget.characterDone) {
                updateLesson();
              }
              _dialogShown = true; // Set flag to prevent multiple dialogs
              _showSuccessDialog();
            } else if (result.recognizedWords.toLowerCase() ==
                    "letter " + widget.lesson.character.toLowerCase() &&
                widget.lesson.type == "standard") {
              if (widget.index == widget.characterDone) {
                updateLesson();
              }
              _dialogShown = true; // Set flag here as well
              _showSuccessDialog();
            } else {
              _dialogShown = true; // Set flag to prevent multiple dialogs
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
    _listeningTimer = Timer(Duration(seconds: 3), () {
      print('Hindi ka nagsasalita');
      _stopListening(); // Stop listening after 2 seconds
    });
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
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/loginRegister/verified.png'),
              SizedBox(height: 5),
              Text(
                'Congratulations',
                style: TextStyle(fontSize: 30),
              ),
              Text('You got it right!'),
            ],
          ),
          actions: [
            Container(
              child: Material(
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    Navigator.pop(context);
                    _dialogShown = false; // Reset flag when dialog is dismissed

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
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF10E119), Color(0xFF18991E)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Okay',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showFailedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/loginRegister/notverified.png'),
              SizedBox(height: 5),
              Text(
                'Try Again',
                style: TextStyle(fontSize: 30),
              ),
              Text("You're almost there!"),
            ],
          ),
          actions: [
            Container(
              child: Material(
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    Navigator.pop(context);
                    _dialogShown = false; // Reset flag when dialog is dismissed
                  },
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF10E119), Color(0xFF18991E)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Okay',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("Selected Item"),
        leading: IconButton(
          onPressed: () {
            // updateLesson();
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => ReadingCharacterSelection(
            //       lesson: widget.lesson,
            //       activity: activity,
            //       lessonNumber: widget.lessonNumber,
            //       lessonTitle: widget.lessonTitle,
            //       // characterDone: characterDone,
            //     ),
            //   ),
            // );
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
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.35,
              right: 90,
              child: SizedBox(
                height: 200, // Change this value to whatever height you need
                width: 200, // Change this value to whatever width you need
                child: Image.asset(
                  widget.lesson.imgPath, // Using widget.imgPath directly
                  fit: BoxFit
                      .fill, // Optional: to control how the image fits in the box
                ),
              ),
            ),
            Positioned(
              bottom: 160,
              right: 80,
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black),
                ),
                child: IconButton(
                  onPressed: sayTheSound,
                  icon: Icon(
                    Icons.repeat,
                    size: 50,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 160,
              left: 80,
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black),
                ),
                child: IconButton(
                  onPressed: _isListening ? _stopListening : _startListening,
                  icon: Icon(
                    Icons.mic_none,
                    size: 50,
                    color: _isListening
                        ? Colors.green
                        : Colors.red, // Change color based on state
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
