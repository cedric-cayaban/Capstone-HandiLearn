import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                    builder: (_) => Home(
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 30,
              ),
              //replace with our own icon data.
            )),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CameraPreview(_controller),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.18,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  color: Colors.black,
                ),
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
                          } else {
                            var flabel = _recognitions[0]['label'].toString();
                            print(flabel);
                            var confidence = _recognitions[0]['confidence'];

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ObjectDescription(
                                    file,
                                    flabel,
                                    confidence,
                                    pickedImageFile),
                              ),
                            );
                          }
                        } on CameraException catch (e) {
                          debugPrint("Error occured while taking picture : $e");
                          return;
                        }
                      },
                      iconSize: 50,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.circle,
                        color: Colors.white,
                        size: 70,
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
