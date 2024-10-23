import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;

class SelectedItem extends StatefulWidget {
  SelectedItem({
    super.key,
    required this.imgPath,
    required this.character,
  });

  final String imgPath;
  final String character;

  @override
  State<SelectedItem> createState() => _SelectedItemState();
}

class _SelectedItemState extends State<SelectedItem> {
  stt.SpeechToText _speech = stt.SpeechToText();

  bool _isListening = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isFinished = false;

  @override
  void initState() {
    super.initState();
    sayTheSound();
    initSpeechState();
  }

  void initSpeechState() async {
    // bool available = await _speech.initialize(
    //   onError: (val) => print('onError: $val'),
    //   onStatus: (val) => print('onStatus: $val'),
    // );
    // if (!mounted) return;

    // if (!available) {
    //   print("Speech recognition is not available on this device.");
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: Text('Speech Recognition Unavailable'),
    //         content:
    //             Text('Speech recognition is not available on this device.'),
    //         actions: [
    //           TextButton(
    //             child: Text('OK'),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
    bool available = await _speech.initialize();
    if (!mounted) return;
  }

  void _startListening() {
    print('natatawag');

    _speech.listen(
      onResult: (result) {
        // Check if the result is final to avoid repeating actions
        if (result.finalResult) {
          print(result.recognizedWords.toLowerCase());

          if (result.recognizedWords.toLowerCase() ==
              widget.character.toLowerCase()) {
            _showSuccessDialog();
            print(result.recognizedWords.toLowerCase());
            isFinished = true;
            setState(() {});
          } else {
            _showFailedDialog();
            print('The result is not correct');
            print(result.recognizedWords.toLowerCase());
          }
        }
      },
    );

    setState(() {
      _isListening = true;
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize:
                MainAxisSize.min, // Ensures the dialog takes minimal space
            children: [
              Image.asset('assets/loginRegister/verified.png'),
              SizedBox(height: 5), // Space between image and text
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
            mainAxisSize:
                MainAxisSize.min, // Ensures the dialog takes minimal space
            children: [
              Image.asset('assets/loginRegister/notverified.png'),
              SizedBox(height: 5), // Space between image and text
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
        AssetSource('insideApp/learnReading/audio/${widget.character}.mp3'),
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
            // widget.character == "A"
            //     ? SizedBox()
            //     : Positioned(
            //         bottom: 30,
            //         left: 25,
            //         child: Container(
            //           width: 115,
            //           height: 38,
            //           child: Material(
            //             borderRadius: BorderRadius.circular(
            //                 10), // Set your desired border radius here
            //             child: InkWell(
            //               borderRadius: BorderRadius.circular(
            //                   10), // Ensure the ripple effect respects the border radius
            //               onTap: null,
            //               child: Container(
            //                 width: double.infinity, // Expand to full width
            //                 height: 45, // Fixed height
            //                 alignment: Alignment.center,
            //                 decoration: BoxDecoration(
            //                   gradient: isFinished
            //                       ? LinearGradient(
            //                           colors: [
            //                             Color(0xFF10E119),
            //                             Color(0xFF18991E)
            //                           ], // Define your gradient colors
            //                           begin: Alignment.topCenter,
            //                           end: Alignment.bottomCenter,
            //                         )
            //                       : LinearGradient(colors: [Colors.grey]),
            //                   borderRadius: BorderRadius.circular(
            //                       10), // Set the same border radius as above
            //                 ),
            //                 child: const Text(
            //                   'Previous',
            //                   style:
            //                       TextStyle(fontSize: 16, color: Colors.white),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            // Positioned(
            //   bottom: 30,
            //   right: 25,
            //   child: Container(
            //     width: 115,
            //     height: 38,
            //     child: Material(
            //       borderRadius: BorderRadius.circular(
            //           10), // Set your desired border radius here
            //       child: InkWell(
            //         borderRadius: BorderRadius.circular(
            //             10), // Ensure the ripple effect respects the border radius
            //         onTap: null,
            //         child: Container(
            //           width: double.infinity, // Expand to full width
            //           height: 45, // Fixed height
            //           alignment: Alignment.center,
            //           decoration: BoxDecoration(
            //             gradient: isFinished
            //                 ? LinearGradient(
            //                     colors: [
            //                       Color(0xFF10E119),
            //                       Color(0xFF18991E)
            //                     ], // Define your gradient colors
            //                     begin: Alignment.topCenter,
            //                     end: Alignment.bottomCenter,
            //                   )
            //                 : LinearGradient(colors: [
            //                     Colors.grey,
            //                     Colors.grey,
            //                   ]),
            //             borderRadius: BorderRadius.circular(
            //                 10), // Set the same border radius as above
            //           ),
            //           child: const Text(
            //             'Next',
            //             style: TextStyle(fontSize: 16, color: Colors.white),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.35,
              right: 90,
              child: SizedBox(
                height: 200, // Change this value to whatever height you need
                width: 200, // Change this value to whatever width you need
                child: Image.asset(
                  widget.imgPath, // Using widget.imgPath directly
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
                  onPressed: _startListening,
                  icon: Icon(
                    Icons.mic_none,
                    size: 50,
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
