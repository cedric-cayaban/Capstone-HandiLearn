import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:test_drawing/screens/1).%20insideapp/1.%20learn/writing/display_result.dart';
import 'package:tflite_v2/tflite_v2.dart';

class HandwritingScanning extends StatefulWidget {
  HandwritingScanning({super.key, required this.word});

  final String word;

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
    await Tflite.loadModel(
      model: "assets/insideApp/scanning/model_unquant.tflite",
      labels: "assets/insideApp/scanning/labels.txt",
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);
    Tflite.close(); // Close the TFLite model when the widget is disposed
    super.dispose();
  }

  Future<File?> _convertAndSaveGrayscale(String imagePath) async {
    final imageBytes = await File(imagePath).readAsBytes();
    final image = img.decodeImage(imageBytes);

    if (image != null) {
      final grayscaleImage = img.grayscale(image);
      final tempDir = await getTemporaryDirectory();
      final processedImagePath =
          '${tempDir.path}/processed_${DateTime.now().millisecondsSinceEpoch}.png';

      final processedImageFile = await File(processedImagePath)
          .writeAsBytes(img.encodePng(grayscaleImage));
      return processedImageFile;
    }
    return null;
  }

  Future<String> detectImage(String imagePath) async {
    final recognitions = await Tflite.runModelOnImage(
      path: imagePath,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() => _recognitions = recognitions);

    if (_recognitions != null && _recognitions.isNotEmpty) {
      final wordFound = _recognitions.any(
        (recognition) =>
            recognition['label'].toString().toUpperCase() ==
                widget.word.toUpperCase() &&
            recognition['confidence'] > 0.01,
      );

      return wordFound
          ? "${widget.word} recognized!"
          : "${widget.word} not recognized.";
    }
    return "No recognitions found.";
  }

  Future<void> _captureAndProcessImage() async {
    try {
      final imageFile = await _controller.takePicture();
      final processedImageFile = await _convertAndSaveGrayscale(imageFile.path);

      if (processedImageFile != null) {
        final label = await detectImage(processedImageFile.path);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayResult(
              imagePath: imageFile.path,
              label: label,
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('nasa handwriting na');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return SafeArea(
      child: Scaffold(
        
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  // Camera preview takes up 80% of the screen height
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: CameraPreview(_controller),
                  ),
                  // Button positioned below the camera preview
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
                            onPressed: _captureAndProcessImage,
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
