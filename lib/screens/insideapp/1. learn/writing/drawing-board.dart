import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show ByteData, DeviceOrientation, SystemChrome, Uint8List, rootBundle;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';
import 'package:test_drawing/objects/lesson.dart';
import 'package:test_drawing/provider/lesson_provider.dart';
import 'package:test_drawing/screens/insideapp/1.%20learn/character_selection.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'dart:ui' as ui;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class DrawingScreen extends StatefulWidget {
  DrawingScreen({
    // required this.type, // 'standard' or 'cursive' or 'number' or 'words'
    // required this.svgPath,
    // required this.character, // Index or identifier for the letter
    // required this.isCapital,
    required this.index,
    required this.lesson,
    required this.forNextLesson,
    required this.lessonNumber,
    required this.lessonField,
  });
  final Lesson lesson;
  List<Lesson> forNextLesson;
  // final String type;
  // final String svgPath;
  // final bool isCapital;
  // final String character;
  final int index;
  final int lessonNumber;
  final String lessonField;

  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<Offset?> drawnPoints = [];
  List<Offset?> resampledPoints = [];
  List<dynamic> _output = [];
  bool isMatch = false;
  bool checkPressed = false;
  bool isLoading = true;

  Map<String, dynamic> guidePoints = {};
  final GlobalKey _drawingAreaKey = GlobalKey(); // Key for the drawing area

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies called');

    // Set orientation based on the number of characters
    if (widget.lesson.character.length > 1 ||
        widget.lesson.type == 'word' ||
        widget.lesson.type == 'cursive word') {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    //BABALIKAN
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadGuidePoints().then((data) {
        setState(() {
          guidePoints = data;
          isLoading = false; // Set loading to false when data is ready
          if (widget.lesson.type == 'word' ||
              widget.lesson.type == 'cursive word') {
            loadModel();
          }
        });
      }).catchError((error) {
        print('Error loading guide points: $error');
        setState(() {
          isLoading = false; // Even on error, stop showing loading indicator
        });
      });
    });
  }

  @override
  void dispose() {
    // Reset the orientation to the default system orientation (or another specific one)
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void updateLesson(LessonProvider provider) async {
    await provider.updateLesson(widget.lessonField, provider.ucharacterDone);
    provider.updateDialogStatus(false); // Reset dialog status
  }

  void loadPopUpModal(bool isMatch) {
    final lessonProvider = Provider.of<LessonProvider>(context, listen: false);
    String checkAsset;
    if (isMatch) {
      checkAsset = 'assets/insideApp/learnWriting/components/dancing.gif';
    } else {
      checkAsset = 'assets/insideApp/learnWriting/components/error.gif';
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        //title: Text('Finished drawing'),
        backgroundColor: Colors.white,
        content: Container(
          color: Colors.white,
          width: 300,
          height: MediaQuery.of(context).size.height *
              ((widget.lesson.type == 'word' ||
                      widget.lesson.type == 'cursive word')
                  ? 0.7
                  : 0.5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: (widget.lesson.type == 'word' ||
                          widget.lesson.type == 'cursive word')
                      ? 150
                      : 300,
                  width: 300,
                  child: Image.asset(checkAsset),
                ),
                Text(
                  isMatch ? 'Great Job!' : 'Oops, Try Again!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: isMatch ? Colors.green : Colors.red,
                  ),
                ),
                const Gap(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          drawnPoints.clear();
                          Navigator.of(context).pop();
                        });
                      },
                      child: SizedBox(
                        height: 70,
                        width: 70,
                        child: Image.asset(
                            'assets/insideApp/learnWriting/components/reload.png'),
                      ),
                    ),
                    if (isMatch &&
                        widget.index < widget.forNextLesson.length - 1)
                      GestureDetector(
                        onTap: () {
                          updateLesson(lessonProvider);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          var nextLesson =
                              widget.forNextLesson[widget.index + 1];
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DrawingScreen(
                              lessonNumber: widget.lessonNumber,
                              index: widget.index + 1,
                              lesson: nextLesson,
                              forNextLesson: widget.forNextLesson,
                              lessonField: widget.lessonField,
                            ),
                          ));
                        },
                        child: SizedBox(
                          height: 70,
                          width: 70,
                          child: Image.asset(
                              'assets/insideApp/learnWriting/components/arrow-forward.png'),
                        ),
                      )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  stt.SpeechToText _speech = stt.SpeechToText();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isFinished = false;

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

  void loadHints() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'How to Write ${widget.lesson.character}',
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Container(
          color: Colors.white,
          height: widget.lesson.hints.length == 1 ? 300 : 600,
          width: 500,
          child: ListView.builder(
            itemCount: widget.lesson.hints.length,
            itemBuilder: (context, index) => Container(
              height: 320,
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      height: 250,
                      width: 250,
                      child: Image.asset(
                        widget.lesson.hints[index],
                      ),
                    ),
                  ),
                  const Gap(20),
                  Text(
                    'Step ${index + 1}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> loadGuidePoints() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/guide_points.json');
      return jsonDecode(jsonString);
    } catch (error) {
      print('Error loading guide points: $error');
      return {}; // Return empty map on error
    }
  }

  List<Offset?> parseGuidePoints(List<dynamic> pointsList, Size canvasSize) {
    List<Offset?> offsets = [];
    for (var point in pointsList) {
      if (point != null) {
        // Check if type is 'word', and if so, assume the width is fixed at 800
        double widthScale = (widget.lesson.type == 'word')
            ? (canvasSize.width / 800)
            : (canvasSize.width / 300); // Default for non-'word' types

        double x = point['dx'] * widthScale;

        // Adjust the height scale based on whether it's a capital letter or a word
        double heightScale;
        if (widget.lesson.type == 'word') {
          heightScale = canvasSize.height / 300; // Fixed height for 'word'
        } else {
          heightScale = widget.lesson.isCapital
              ? canvasSize.height / 300 // Capital: height 300
              : canvasSize.height / 250; // Small: height 250
        }
        double y = point['dy'] * heightScale;

        offsets.add(Offset(x, y));
      } else {
        offsets.add(null); // Handle null points for stroke separation
      }
    }
    return offsets;
  }

  loadModel() async {
    String model = '';
    String label = '';
    if (widget.lesson.type == 'word') {
      model = 'assets/models/word/standard/word-standard.tflite';
      label = 'assets/models/word/standard/word-standard.txt';
    } else if (widget.lesson.type == 'cursive word') {
      model = 'assets/models/word/cursive/word-cursive.tflite';
      label = 'assets/models/word/cursive/word-cursive.txt';
    }
    //MAS OKS ATA YUNG NAKA HATI SA DALAWA, MAS DAMI SA TOP 3? | GAWING TOP 4 UNG COCORRECT
    await Tflite.loadModel(
      // model: 'assets/standard-capital.tflite',
      // labels: 'assets/standard-capital.txt',
      model: model,
      labels: label,
    );
  }

  Future<File?> convertDrawingToImage() async {
    try {
      // Set the width and height conditionally based on widget.type

      final double contentWidth =
          (widget.lesson.type == 'word' || widget.lesson.type == 'cursive word')
              ? 800
              : 300;
      final double contentHeight =
          widget.lesson.type == 'word' ? 300 : 300; // Original content height

      // Ensure the final image is square
      final double squareSize =
          contentWidth > contentHeight ? contentWidth : contentHeight;
      final double paddingX = (squareSize - contentWidth) / 2;
      final double paddingY = (squareSize - contentHeight) / 2;

      // Create a new image with padding if necessary
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder,
          Rect.fromPoints(Offset(0, 0), Offset(squareSize, squareSize)));

      Paint paint = Paint()
        ..color = Colors.blue
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 20.0;

      // Shift the drawing to be centered with padding
      canvas.translate(paddingX, paddingY);

      // Draw only the points on the canvas
      for (int i = 0; i < drawnPoints.length - 1; i++) {
        if (drawnPoints[i] != null && drawnPoints[i + 1] != null) {
          canvas.drawLine(drawnPoints[i]!, drawnPoints[i + 1]!, paint);
        }
      }

      // End the recording and convert to image
      final picture = recorder.endRecording();
      final image =
          await picture.toImage(squareSize.toInt(), squareSize.toInt());

      // Convert to byte data and save the image
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final Directory tempDir = await Directory.systemTemp.createTemp();
        final File file = File('${tempDir.path}/drawing.png');
        await file.writeAsBytes(byteData.buffer.asUint8List());
        return file;
      }
    } catch (e) {
      print('Error converting image: $e');
    }
    return null;
  }

  bool isSpecificWordCheck(String targetWord, List<dynamic> output) {
    // Define a map for valid predictions under 'word'
    Map<String, List<String>> wordPredictions = {
      "pig": ["pig", "cat"],
      "bike": ["bike", "kite"],
    };

    // Define a map for valid predictions under 'cursive word'
    Map<String, List<String>> cursiveWordPredictions = {
      "cat": ["bike"],
      "dog": ["pig"],
      "kite": ["at"],
      "apple": ["in"],
    };

    Map<String, List<String>>? validPredictions;

    // Determine which map to use based on widget type
    if (widget.lesson.type == 'word') {
      validPredictions = wordPredictions;
    } else if (widget.lesson.type == 'cursive word') {
      validPredictions = cursiveWordPredictions;
    }

    // If the target word has valid predictions in the appropriate map
    if (validPredictions != null && validPredictions.containsKey(targetWord)) {
      for (int i = 0; i < output.length && i < 3; i++) {
        String predictionLabel = output[i]['label'].split(' ')[1];
        // Check if the prediction matches any valid prediction for the target word
        if (validPredictions[targetWord]!.contains(predictionLabel)) {
          return true;
        }
      }
    }

    return false; // Return false if no specific word match is found
  }

  Future<void> classifyDrawing(List<Offset?> wordGuidePoints) async {
    try {
      // Ensure guidePoints and resampledPoints are populated
      print("resampledPoints length: ${resampledPoints.length}");
      print(
          "guidePoints length for ${widget.lesson.type} ${widget.lesson.character}: ${wordGuidePoints.length}");

      if (resampledPoints.length < (wordGuidePoints.length * 0.90)) {
        setState(() {
          isMatch = false; // Early exit if not enough points
        });
        print("Not enough points, returning false.");
        return;
      }

      File? imageFile = await convertDrawingToImage();

      if (imageFile == null) {
        print("Image conversion failed");
        return;
      }

      // Preprocess the image before passing it to the model
      File? preprocessedFile = await preprocessImage(imageFile);
      if (preprocessedFile == null) {
        print("Image preprocessing failed");
        return;
      }

      // Run the model on the preprocessed image file
      var output = await Tflite.runModelOnImage(
        path: preprocessedFile
            .path, // Use the path of the preprocessed image file
        threshold: 0.0, // Set the threshold to 0 to get all results
        asynch: true, // Use asynchronous processing
      );

      if (output != null && output.isNotEmpty) {
        // Sort the output by confidence level
        output.sort((a, b) => b['confidence'].compareTo(a['confidence']));

        // Print the top 3 predictions for debugging
        print("Top 3 Predictions:");
        for (int i = 0; i < output.length && i < 3; i++) {
          print(
              "Prediction ${i + 1}: ${output[i]['label']} with confidence ${output[i]['confidence']}");
        }

        // Checking if any of the top 3 labels matches the target character
        bool matchFound = false;

        for (int i = 0; i < output.length && i < 3; i++) {
          String label = output[i]['label']
              .split(' ')[1]; // Extract the character part of the label
          if (label == widget.lesson.character) {
            matchFound = true;
            break;
          }
        }

        // Use isSpecificWordCheck to handle specific word cases like "pig"
        if (!matchFound) {
          matchFound = isSpecificWordCheck(widget.lesson.character, output);
        }

        // Update the state with the classification result
        setState(() {
          _output = output;
          isMatch = matchFound;
        });
      } else {
        print("Model failed to classify the image.");
      }
    } catch (e) {
      print("Error during classification: $e");
    }
  }

  // New preprocessing function
  // Preprocess image: resize and normalize
  Future<File?> preprocessImage(File imageFile) async {
    try {
      // Read the image file as bytes
      Uint8List imageBytes = await imageFile.readAsBytes();

      // Decode the image
      img.Image? originalImage = img.decodeImage(imageBytes);

      // Ensure the original image is valid
      if (originalImage == null) {
        print('Error: Original image is null.');
        return null; // Return null if the original image is invalid
      }

      // Resize the image to 224x224
      img.Image resizedImage =
          img.copyResize(originalImage, width: 224, height: 224);

      // Encode the resized image back to PNG format
      Uint8List resizedBytes = img.encodePng(resizedImage);

      // Create a temporary directory to save the preprocessed image
      final Directory tempDir = await Directory.systemTemp.createTemp();
      final File preprocessedFile =
          File('${tempDir.path}/preprocessed_image.png');

      // Write the resized bytes to the new file
      await preprocessedFile.writeAsBytes(resizedBytes);
      return preprocessedFile; // Return the preprocessed image file
    } catch (e) {
      print('Error in image preprocessing: $e');
      return null; // Return null if there's an error
    }
  }

  List<List<Offset>> splitIntoStrokes(List<Offset?> points) {
    List<List<Offset>> strokes = [];
    List<Offset> currentStroke = [];

    for (var point in points) {
      if (point == null) {
        if (currentStroke.isNotEmpty) {
          strokes.add(currentStroke);
          currentStroke = [];
        }
      } else {
        currentStroke.add(point);
      }
    }

    if (currentStroke.isNotEmpty) {
      strokes.add(currentStroke);
    }

    return strokes;
  }

  bool drawingChecker(
      List<Offset?> userPoints, List<Offset?> guidePoints, double threshold) {
    // Function to split points into strokes based on null values

    List<List<Offset>> userStrokes = splitIntoStrokes(userPoints);
    List<List<Offset>> guideStrokes = splitIntoStrokes(guidePoints);

    // Compare each stroke
    if (userStrokes.length < guideStrokes.length) {
      print(
          'Number of strokes does not match: ${userStrokes.length} vs ${guideStrokes.length}');
      return false; // If the number of strokes is different, return false
    } else if (userStrokes.length > guideStrokes.length) {
      print('Number of strokes exceed the correct amount');
      return false; // If the number of strokes is different, return false
    }

    for (int i = 0; i < guideStrokes.length; i++) {
      List<Offset> userStroke = userStrokes[i];
      List<Offset> guideStroke = guideStrokes[i];

      // Check points in the stroke
      for (int j = 0; j < guideStroke.length; j++) {
        if (j < userStroke.length) {
          // Compare user stroke and guide stroke points
          if ((userStroke[j] - guideStroke[j]).distance > threshold) {
            print(
                'Point mismatch in stroke $i at index $j: ${userStroke[j]} vs ${guideStroke[j]}');
            return false; // If any point in the stroke doesn't match, return false
          }
        } else {
          // If user stroke is shorter, allow some flexibility with the last point
          // Check the distance between the last user point and the remaining guide points
          final lastUserPoint = userStroke.last;
          for (int k = j; k < guideStroke.length; k++) {
            if ((lastUserPoint - guideStroke[k]).distance > threshold) {
              print('User stroke $i is too short and far from guide stroke $k');
              return false; // Mismatch if last point is too far from remaining guide points
            }
          }
          // If we reach here, it means the last point is close enough, allow the match
          break;
        }
      }

      // Check if the last point of the user stroke is too far from the last guide stroke point
      if (userStroke.length > guideStroke.length) {
        // Check distance between the last points
        if ((userStroke.last - guideStroke.last).distance > threshold) {
          print('User stroke $i exceeds the endpoint of guide stroke $i');
          return false; // If the last user stroke point is too far from the guide stroke point
        }
      }
    }

    return true; // All strokes and points match
  }

  List<Offset?> resamplePoints(List<Offset?> points, double interval) {
    List<Offset?> resampledPoints = [];
    if (points.isEmpty) return resampledPoints;

    double distance(Offset a, Offset b) {
      return (a - b).distance;
    }

    double remainingDistance = interval;
    resampledPoints.add(points.first);

    for (int i = 1; i < points.length; i++) {
      if (points[i] == null || points[i - 1] == null) {
        resampledPoints.add(null);
        continue;
      }

      double dist = distance(points[i - 1]!, points[i]!);

      while (dist >= remainingDistance) {
        double t = remainingDistance / dist;
        Offset interpolatedPoint = Offset.lerp(points[i - 1]!, points[i]!, t)!;
        resampledPoints.add(interpolatedPoint);
        dist -= remainingDistance;
        remainingDistance = interval;
      }

      remainingDistance -= dist;
    }

    return resampledPoints;
  }

  List<Offset?> getGuidePoints(
      String letterType, String characterKey, Size canvasSize) {
    if (guidePoints.isEmpty) {
      return [];
    }

    List<dynamic> pointsJson = guidePoints[letterType][characterKey];
    return parseGuidePoints(pointsJson, canvasSize);
  }

  Widget loadSvg(String path) {
    try {
      return SvgPicture.asset(
        path,
        fit: BoxFit.contain,
        color: Colors.black.withOpacity(0.5),
      );
    } catch (e) {
      print('Error loading SVG: $e');
      return Center(child: Text('Error loading SVG'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double canvasHeight = widget.lesson.isCapital ? 300.0 : 250.0;
    // Set width to 800 if type is 'word', otherwise 300
    final double canvasWidth =
        (widget.lesson.type == 'word' || widget.lesson.type == 'cursive word')
            ? 800.0
            : 300.0; // Updated to 800

    String characterKey = widget.lesson.character;
    Size canvasSize = Size(canvasWidth, canvasHeight);

    //BABALIKAN
    List<Offset?> guidePointsForLetter =
        getGuidePoints(widget.lesson.type, characterKey, canvasSize);

    return SafeArea(
      child: Scaffold(
        appBar: null,
        //WORD
        body: (widget.lesson.type == 'word' ||
                widget.lesson.type == 'cursive word')
            ? Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                          onPressed: () async {
                            await SystemChrome.setPreferredOrientations([
                              DeviceOrientation.portraitUp,
                              DeviceOrientation.portraitDown,
                            ]);
                            Navigator.of(context).pop();
                            // Navigator.of(context).pop();
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => CharacterSelectionScreen(
                            //         lesson: widget.forNextLesson,
                            //         activity: 'Writing',
                            //         lessonNumber: widget.lessonNumber)));
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          //SCAN BUTTON
                          child: GestureDetector(
                            onTap: () {},
                            child: Column(
                              children: [
                                Container(
                                  width: 30.0,
                                  height: 35.0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape
                                        .circle, // Makes the container circular
                                  ),
                                  child: Image.asset(
                                    'assets/insideApp/learnWriting/components/scan.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const Text('Scan'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          RenderBox? renderBox = _drawingAreaKey.currentContext
                              ?.findRenderObject() as RenderBox?;
                          if (renderBox != null) {
                            Offset localPosition =
                                renderBox.globalToLocal(details.globalPosition);

                            // Trigger the state change immediately for smoother updates
                            setState(() {
                              drawnPoints = List.from(drawnPoints)
                                ..add(localPosition);
                            });
                          }
                        },
                        onPanEnd: (details) {
                          setState(() {
                            drawnPoints.add(null);
                            resampledPoints = resamplePoints(
                                drawnPoints, 5.0); // Store resampled points
                            print(
                                'Resampled Drawn points after pan end for ${widget.lesson.character}: \n $resampledPoints \n\n');
                          });
                        },
                        child: Center(
                          child: CustomPaint(
                            painter: DrawingBoard(drawnPoints),
                            child: Container(
                              key: _drawingAreaKey,
                              height: canvasHeight,
                              width:
                                  canvasWidth, // Width adjusted based on 'word'
                              child: loadSvg(widget.lesson.svgPath),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await classifyDrawing(guidePointsForLetter);
                        checkPressed = true;

                        setState(() {
                          loadPopUpModal(isMatch);
                        });
                      },
                      child: Text(
                        'Check',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              )
            // LETTERS
            : Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // BACK BUTTON
                        IconButton(
                          icon: const Icon(
                            size: 30,
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => CharacterSelectionScreen(
                            //         lesson: widget.forNextLesson,
                            //         activity: 'Writing',
                            //         lessonNumber: widget.lessonNumber)));
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10, top: 20),
                          // TOP RIGHT BUTTONS
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  sayTheSound();
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 30.0,
                                      height: 30.0,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset(
                                        'assets/insideApp/learnWriting/components/sound.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const Text('Sound'),
                                  ],
                                ),
                              ),
                              const Gap(15),
                              GestureDetector(
                                onTap: () {
                                  //HINT
                                  loadHints();
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 30.0,
                                      height: 30.0,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset(
                                        'assets/insideApp/learnWriting/components/hint.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const Text('Hint'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 200.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onPanUpdate: (details) {
                                RenderBox? renderBox = _drawingAreaKey
                                    .currentContext
                                    ?.findRenderObject() as RenderBox?;
                                if (renderBox != null) {
                                  Offset localPosition = renderBox
                                      .globalToLocal(details.globalPosition);

                                  // Trigger the state change immediately for smoother updates
                                  setState(() {
                                    drawnPoints = List.from(drawnPoints)
                                      ..add(localPosition);
                                  });
                                }
                              },
                              onPanEnd: (details) {
                                setState(() {
                                  drawnPoints.add(null);
                                  resampledPoints = resamplePoints(drawnPoints,
                                      5.0); // Store resampled points
                                  print(
                                      'Resampled Drawn points after pan end for ${widget.lesson.character}: \n $resampledPoints \n\n');
                                });
                              },
                              child: Center(
                                child: CustomPaint(
                                  painter: DrawingBoard(drawnPoints),
                                  child: Container(
                                    key: _drawingAreaKey,
                                    height: canvasHeight,
                                    width:
                                        canvasWidth, // Width adjusted based on 'word'
                                    child: loadSvg(widget.lesson.svgPath),
                                  ),
                                ),
                              ),
                            ),
                            Gap(125),
                            ElevatedButton(
                              onPressed: () async {
                                if (guidePoints.isEmpty) {
                                  print('Guide points not loaded yet');
                                  return;
                                }

                                checkPressed = true;
                                // Checking the match using the current canvas size
                                // BABALIKAN ANDITO THRESHOLD
                                List<Offset?> guidePointsForLetter =
                                    getGuidePoints(widget.lesson.type,
                                        characterKey, canvasSize);

                                isMatch = drawingChecker(
                                    resampledPoints,
                                    getGuidePoints(widget.lesson.type,
                                        characterKey, canvasSize),
                                    widget.lesson.type == 'number'
                                        ? 70
                                        : 50); // Threshold

                                setState(() {
                                  loadPopUpModal(isMatch);
                                });
                              },
                              child: Text(
                                'Check',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class DrawingBoard extends CustomPainter {
  final List<Offset?> points;

  DrawingBoard(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 20.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingBoard oldDelegate) {
    //return oldDelegate.points != points;
    return true;
  }
}
