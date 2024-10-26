import 'package:flutter/material.dart';
import 'package:test_drawing/objects/lesson.dart';
import 'package:test_drawing/screens/insideapp/1.%20learn/activity_screen.dart';
import 'package:test_drawing/screens/insideapp/1.%20learn/lesson_screen.dart';
import 'package:test_drawing/screens/insideapp/1.%20learn/writing/drawing-board.dart';

class CharacterSelectionScreen extends StatefulWidget {
  CharacterSelectionScreen({
    super.key,
    required this.lesson,
    required this.activity,
    required this.lessonNumber,
  });
  List<Lesson> lesson;
  String activity;
  int lessonNumber;

  @override
  State<CharacterSelectionScreen> createState() =>
      _LetterSelectionsScreenState();
}

List<String> boardBg = [
  'assets/insideApp/learnWriting/components/board-bg-1.png',
];

List<String> lessonTitles = [
  'Capital Letters',
  'Small Letters',
  'Words',
  'Numbers',
  'Capital Cursives',
  'Small Cursives',
  'Cursive Words'
];

class _LetterSelectionsScreenState extends State<CharacterSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.37,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/insideApp/learnWriting/components/selection-visual${widget.lessonNumber + 1}.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 10,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: widget.lessonNumber == 3 || widget.lessonNumber == 6
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: () {
                  if (widget.lessonNumber == 0 ||
                      widget.lessonNumber == 2 ||
                      widget.lessonNumber == 3) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ActivityScreen(
                            lesson: widget.lesson,
                            lessonTitle: lessonTitles[widget.lessonNumber],
                            lessonNumber: widget.lessonNumber),
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LessonScreen(),
                      ),
                    );
                  }
                },
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.33,
              left: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                height: MediaQuery.of(context).size.height * 0.7,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 70,
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1, // Keep the grid cells square
                            crossAxisSpacing:
                                16, // Space between grid items horizontally
                            mainAxisSpacing:
                                16, // Space between grid items vertically
                          ),
                          itemCount: widget.lesson.length,
                          padding: const EdgeInsets.all(
                              16), // Padding around the grid
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DrawingScreen(
                                  
                                  lessonNumber: widget.lessonNumber,
                                  forNextLesson: widget.lesson,
                                  lesson: widget.lesson[index],
                                  index: index,
                                ),
                              ));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    16.0), // Space inside the card
                                child: Image.asset(
                                  widget.lesson[index].imgPath,
                                  fit: BoxFit
                                      .contain, // Scale the image but don't cut it off
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.275,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                      'assets/insideApp/learnWriting/components/selection-img.png')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}