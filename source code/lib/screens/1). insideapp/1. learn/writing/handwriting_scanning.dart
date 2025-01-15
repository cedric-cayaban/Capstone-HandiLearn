import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:test_drawing/provider/lesson_provider.dart';
import 'package:test_drawing/screens/1).%20insideapp/home.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'dart:math' as math;

class HandwritingScanning extends StatefulWidget {
  HandwritingScanning({
    super.key,
    required this.word,
    required this.wordImage,
    required this.characterDone,
    required this.lessonField,
    required this.index,
  });

  final String word;
  final String wordImage;
  final int characterDone;
  final String lessonField;
  final int index;

  @override
  State<HandwritingScanning> createState() => _HandwritingScanningState();
}

class _HandwritingScanningState extends State<HandwritingScanning> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  var _recognitions;
  var v = "";

  @override
  void initState() {
    super.initState();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);
    _initializeControllerFuture = _initializeCamera();
    loadModel();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    await _controller.initialize();
    await _controller.setFlashMode(FlashMode.auto);
  }

  Future<void> loadModel() async {
    print('model initialize');
    await Tflite.loadModel(
      model: "assets/insideApp/scanning/model_unquant.tflite",
      labels: "assets/insideApp/scanning/labels.txt",
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitDown,
    //   DeviceOrientation.portraitUp,
    // ]);
    Tflite.close();
    super.dispose();
  }

  // Future<File?> _convertAndSaveGrayscale(String imagePath) async {
  //   final imageBytes = await File(imagePath).readAsBytes();
  //   final image = img.decodeImage(imageBytes);

  //   if (image != null) {
  //     final grayscaleImage = img.grayscale(image);
  //     final tempDir = await getTemporaryDirectory();
  //     final processedImagePath =
  //         '${tempDir.path}/processed_${DateTime.now().millisecondsSinceEpoch}.png';

  //     final processedImageFile = await File(processedImagePath)
  //         .writeAsBytes(img.encodePng(grayscaleImage));
  //     return processedImageFile;
  //   }
  //   return null;
  // }

  // Future<String> detectImage(String imagePath) async {
  //   final recognitions = await Tflite.runModelOnImage(
  //     path: imagePath,
  //     numResults: 6,
  //     threshold: 0.05,
  //     imageMean: 127.5,
  //     imageStd: 127.5,
  //   );

  //   setState(() => _recognitions = recognitions);

  //   if (_recognitions != null && _recognitions.isNotEmpty) {
  //     final wordFound = _recognitions.any(
  //       (recognition) =>
  //           recognition['label'].toString().toUpperCase() ==
  //               widget.word.toUpperCase() &&
  //           recognition['confidence'] > 0.5,
  //     );

  //     return wordFound
  //         ? "${widget.word} recognized!"
  //         : "${widget.word} not recognized.";
  //   }
  //   return "No recognitions found.";
  // }

  // Future<void> _captureAndProcessImage() async {
  //   try {
  //     final imageFile = await _controller.takePicture();
  //     final processedImageFile = await _convertAndSaveGrayscale(imageFile.path);

  //     if (processedImageFile != null) {
  //       final label = await detectImage(processedImageFile.path);

  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => DisplayResult(
  //             imagePath: imageFile.path,
  //             label: label,
  //           ),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future detectimage(String image) async {
    print('detected image');
    int startTime = DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.runModelOnImage(
      path: image,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _recognitions = recognitions;
      v = recognitions.toString();
    });
    print(v);

    print(_recognitions);
    int endTime = DateTime.now().millisecondsSinceEpoch;
    return v;
  }

  void updateLesson(LessonProvider provider) async {
    print("updateLesson");
    await provider.updateLesson(widget.lessonField, widget.characterDone);
    provider.updateDialogStatus(false); // Reset dialog status
  }

  void showRotatedSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Transform.rotate(
          angle: math.pi / 2, // Rotates the dialog by 45 degrees
          child: Theme(
            data: Theme.of(context).copyWith(
              dialogBackgroundColor:
                  Colors.white, // Change to your desired color
            ),
            child: AlertDialog(
              backgroundColor: Colors.white,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/insideApp/learnReading/read.gif',
                    height: 190,
                    width: 300,
                  ),
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
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.pop(context);
                      //   },
                      //   child: Column(
                      //     children: [
                      //       SizedBox(
                      //         height: 70,
                      //         width: 70,
                      //         child: Image.asset(
                      //             'assets/insideApp/learnReading/next.png'),
                      //       ),
                      //       Text(
                      //         'Next Letter',
                      //         style: TextStyle(fontSize: 14),
                      //       )
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showRotatedErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white, // Change to your desired color
          ),
          child: Transform.rotate(
            angle: math.pi / 2, // Rotates the dialog by 45 degrees
            child: AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/insideApp/learnReading/sorry.gif'),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: SizedBox(),
          actions: [
            Transform.rotate(
              angle: 3.14 / 2,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => Home()));
                  },
                  icon: Icon(
                    Icons.home,
                    color: Colors.white,
                  )),
            )
          ],
        ),
        extendBodyBehindAppBar: true,
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Camera preview takes up 80% of the screen height
                  Positioned(
                    top: 0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * .8,
                      child: CameraPreview(_controller),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .2,
                        decoration: BoxDecoration(color: Colors.black),
                      )),
                  // Button positioned below the camera preview
                  // Positioned(
                  //   top: 5,
                  //   right: 5,
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       Navigator.pushReplacement(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (_) => Home(),
                  //         ),
                  //       );
                  //     },
                  //     child: Container(
                  //       color: Colors.white, // Change this color for testing
                  //       child: Icon(Icons.arrow_upward),
                  //     ),
                  //   ),
                  // ),

                  Positioned(
                    // alignment: Alignment.center,
                    top: MediaQuery.of(context).size.height * .15,
                    child: Container(
                      decoration: BoxDecoration(
                          // color: Colors.red,
                          ),
                      child: Image.asset(
                        'assets/insideApp/scanning/scanning.png',
                        height: MediaQuery.of(context).size.height * .5,
                        width: MediaQuery.of(context).size.height * .4,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * .15,
                    child: Container(
                      decoration: BoxDecoration(
                          // color: Colors.red,
                          ),
                      child: Image.asset(
                        'assets/insideApp/scanning/scanner red.gif',
                        height: MediaQuery.of(context).size.height * .5,
                        width: MediaQuery.of(context).size.height * .4,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 30,
                    child: Transform.rotate(
                      angle:
                          3.14 / 2, // 45 degrees in radians; adjust as needed
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            "assets/insideApp/scanning/writing image/${widget.word}.png",
                            height: 80,
                            width: 100,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.18,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: IconButton(
                            onPressed: () async {
                              try {
                                final imageFile =
                                    await _controller.takePicture();

                                // Call detectImage and await its completion to update _recognitions
                                await detectimage(imageFile.path);
                                print(_recognitions);
                                print(widget.word);

                                final lessonProvider =
                                    Provider.of<LessonProvider>(context,
                                        listen: false);

                                // Check if _recognitions is not null or empty before accessing it
                                if (_recognitions != null &&
                                    _recognitions.isNotEmpty) {
                                  if (_recognitions[0]['confidence'] > 0.4 &&
                                      _recognitions[0]['label']
                                              .toString()
                                              .toUpperCase() ==
                                          widget.word
                                              .toString()
                                              .toUpperCase()) {
                                    if (widget.index ==
                                        lessonProvider.ucharacterDone) {
                                      updateLesson(lessonProvider);
                                    }
                                    showRotatedSuccessDialog(context);
                                  } else {
                                    showRotatedErrorDialog(context);
                                  }
                                } else {
                                  // Handle case where no recognitions were found
                                  print('No recognitions found');
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.error,
                                    title: 'Error',
                                    text:
                                        'No recognitions found, please try again.',
                                  );
                                }
                              } catch (e) {
                                print('Error during scanning');
                                print(e);
                              }
                            },
                            iconSize: 80,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.camera_outlined,
                              color: Colors.white,
                              size: 100,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
