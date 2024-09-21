import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show DeviceOrientation, SystemChrome, rootBundle;
import 'package:flutter_svg/flutter_svg.dart';

class DrawingScreen extends StatefulWidget {
  DrawingScreen({
    required this.type, // 'standard' or 'cursive' or 'number' or 'words'
    required this.svgPath,
    required this.character, // Index or identifier for the letter
    required this.isCapital,
  });

  final String type;
  final String svgPath;
  final bool isCapital;
  final String character;

  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<Offset?> drawnPoints = [];
  List<Offset?> resampledPoints = [];
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
    if (widget.character.length > 1 || widget.type == 'word') {
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
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   loadGuidePoints().then((data) {
    //     // setState(() {
    //     //   guidePoints = data;
    //     //   isLoading = false; // Set loading to false when data is ready
    //     // });
    //     guidePoints = data;
    //     isLoading = false;
    //   }).catchError((error) {
    //     print('Error loading guide points: $error');
    //     // setState(() {
    //     //   isLoading = false; // Even on error, stop showing loading indicator
    //     // });
    //     isLoading = false;
    //   });
    // });
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
        double x = point['dx'] *
            (canvasSize.width / 300); // Width is based on canvas size
        double y = widget.isCapital
            ? point['dy'] * (canvasSize.height / 300) // Capital: height 300
            : point['dy'] * (canvasSize.height / 250); // Small: height 250
        offsets.add(Offset(x, y));
      } else {
        offsets.add(null);
      }
    }
    return offsets;
  }

  bool drawingChecker(
      List<Offset?> userPoints, List<Offset?> guidePoints, double threshold) {
    // Check if the user has drawn anything
    if (userPoints.isEmpty || guidePoints.isEmpty) {
      print('User has not drawn anything or guide points are missing.');
      return false;
    }

    // Iterate over the points and compare
    for (int i = 0; i < guidePoints.length; i++) {
      if (i >= userPoints.length || userPoints[i] == null) {
        print('Point $i is null or out of bounds');
        continue;
      }

      if (guidePoints[i] == null) {
        print('Guide point $i is null');
        continue;
      }

      if ((userPoints[i]! - guidePoints[i]!).distance > threshold) {
        print('Point $i mismatch: ${userPoints[i]} vs ${guidePoints[i]}');
        return false;
      }
    }

    return true;
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
    final double canvasHeight = widget.isCapital ? 300.0 : 250.0;
    // Set width to 800 if type is 'word', otherwise 300
    final double canvasWidth =
        widget.type == 'word' ? 800.0 : 300.0; // Updated to 800

    String characterKey = widget.character;
    Size canvasSize = Size(canvasWidth, canvasHeight);

    //BABALIKAN
    // List<Offset?> guidePointsForLetter =
    //     getGuidePoints(widget.type, characterKey, canvasSize);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
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
                      drawnPoints = List.from(drawnPoints)..add(localPosition);
                    });
                  }
                },
                onPanEnd: (details) {
                  setState(() {
                    drawnPoints.add(null);
                    resampledPoints = resamplePoints(
                        drawnPoints, 5.0); // Store resampled points
                    print(
                        'Resampled Drawn points after pan end for ${widget.character}: \n $resampledPoints \n\n');
                  });
                },
                child: Center(
                  child: CustomPaint(
                    painter: DrawingBoard(drawnPoints),
                    child: Container(
                      key: _drawingAreaKey,
                      height: canvasHeight,
                      width: canvasWidth, // Width adjusted based on 'word'
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: loadSvg(widget.svgPath),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (guidePoints.isEmpty) {
                  print('Guide points not loaded yet');
                  return;
                }

                setState(() {
                  checkPressed = true;
                  // BABALIKAN ANDITO THRESHOLD
                  // List<Offset?> guidePointsForLetter =
                  //     getGuidePoints(widget.type, characterKey, canvasSize);

                  // Checking the match using the current canvas size
                  isMatch = drawingChecker(
                      resampledPoints,
                      getGuidePoints(widget.type, characterKey, canvasSize),
                      30); // Threshold

                  if (isMatch) {
                    print('Drawing matches!');
                  } else {
                    print('Drawing does not match.');
                  }
                });
              },
              child: Text(
                'Check Drawing',
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            if (checkPressed)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  isMatch ? 'Match!' : 'Incorrect!',
                  style: TextStyle(
                    fontSize: 24,
                    color: isMatch ? Colors.green : Colors.red,
                  ),
                ),
              ),
          ],
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
      ..strokeWidth = 27.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingBoard oldDelegate) {
    return oldDelegate.points != points;
  }
}
