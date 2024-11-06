import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:test_drawing/data/objects.dart';
import 'package:test_drawing/screens/insideapp/3.%20scanning/image_description.dart';
import 'package:test_drawing/screens/insideapp/home.dart';
import 'package:tflite_v2/tflite_v2.dart';

import '../../../main.dart';

class CameraScreen extends StatefulWidget {
  CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _nameState();
}

class _nameState extends State<CameraScreen> {
  late CameraController _controller;
  File? file;
  var _recognitions;
  var v = "";
  int _randomNumber = 0;

  List<String> labels = [
    'BAG',
    'BOOK',
    'CHAIR',
    'RULER',
    'PENCIL',
    'NOTEBOOK',
    'CRAYONS',
    'ERASER',
    'SHOES',
    'SCISSORS'
  ];

  @override
  void initState() {
    super.initState();
    loadmodel().then((value) {
      setState(() {});
    });
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});

      randomTheObjects();
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('Access denied');
            break;
          default:
            print(e.description);
            break;
        }
      }
    });
  }

  void randomTheObjects() {
    setState(() {
      _randomNumber = Random().nextInt(10);
    });
    print(_randomNumber);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize:
                MainAxisSize.min, // Ensures the dialog takes minimal space
            children: [
              Image.asset(
                  'assets/insideApp/scanning/objects/$_randomNumber.gif'),
            ],
          ),
          actions: [
            Container(
              child: Material(
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    pickedNum = _randomNumber;
                    Navigator.of(context).pop();
                    // Navigator.of(context).pushReplacement(
                    //     MaterialPageRoute(builder: (_) => CameraScreen()));
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
                      "Let's find it",
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

  void _showDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Icon(
              Icons.error,
              size: 50,
              color: Colors.red.shade500,
            ),
            content: const Text(
                'The image is too blurry or unclear. Please capture a sharp and well-lit image.'),
            actions: [
              Center(
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Got it!'),
                ),
              )
            ],
          );
        });
  }

  loadmodel() async {
    await Tflite.loadModel(
      model: "assets/insideApp/scanning/model/model.tflite",
      labels: "assets/insideApp/scanning/model/label.txt",
    );
  }

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
      // dataList = List<Map<String, dynamic>>.from(jsonDecode(v));
    });
    print(v);
    //print("//////////////////////////////////////////////////");
    print(_recognitions);
    // print(dataList);
    //print("//////////////////////////////////////////////////");
    int endTime = DateTime.now().millisecondsSinceEpoch;
    //print("Inference took ${endTime - startTime}ms");
    return v;
  }

  void _showFailedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
                          'assets/insideApp/scanning/try again.png'),
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (_) => Home(),
                ),
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 30,
              color: Colors.white,
            ),
            //replace with our own icon data.
          ),
          actions: [
            // IconButton(
            //   onPressed: () {},
            //   icon: Icon(Icons.read_more),
            // ),
            // IconButton(
            //   onPressed: () {},
            //   icon: Icon(Icons.branding_watermark_outlined),
            // ),
            Image.asset('assets/insideApp/scanning/instruction.png'),
            Gap(15),
            Image.asset('assets/insideApp/scanning/tips.png'),
            Gap(10),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CameraPreview(_controller),
            ),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/insideApp/scanning/scanner.png',
                height: double.infinity * .8,
                width: double.infinity * .8,
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
                          await _controller.setFlashMode(FlashMode.auto);
                          XFile file = await _controller.takePicture();
                          File pickedImageFile = File(file.path);
                          print(pickedImageFile);
                          await detectimage(file.path);
                          //eto yung tama

                          print(_recognitions[0]['confidence']);

                          if (_recognitions[0]['confidence'] < .75) {
                            print("try again");
                            _showDialog();
                          } else if (labels[pickedNum] ==
                              _recognitions[0]['label'].toString()) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ObjectDescription(
                                    file,
                                    _recognitions[0]['label'].toString(),
                                    _recognitions[0]['confidence'],
                                    pickedImageFile),
                              ),
                            );
                          } else {
                            _showFailedDialog();
                          }
                        } on CameraException catch (e) {
                          debugPrint("Error occured while taking picture : $e");
                          return;
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
        ),
      ),
    );
  }
}
