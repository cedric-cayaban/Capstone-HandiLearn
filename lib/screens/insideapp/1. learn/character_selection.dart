import 'package:flutter/material.dart';
import 'package:test_drawing/objects/lesson.dart';
import 'package:test_drawing/screens/insideapp/1.%20learn/drawing-board.dart';

class CharacterSelectionScreen extends StatefulWidget {
  const CharacterSelectionScreen(
      {super.key, required this.lesson, required this.activity,
      required this.lessonNumber,
      
      });
  final List<Lesson> lesson;
  final String activity;
  final int lessonNumber;
  

  @override
  State<CharacterSelectionScreen> createState() =>
      _LetterSelectionsScreenState();
}

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
                  'assets/images/components/selection-visual${widget.lessonNumber + 1}.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 10,
              child: IconButton(
                icon:  Icon(
                  Icons.arrow_back,
                  color: widget.lessonNumber == 3 || widget.lessonNumber == 6 ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
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
                                  type: widget.lesson[index].type,
                                  svgPath: widget.lesson[index].svgPath,
                                  character: widget.lesson[index].character,
                                  isCapital: widget.lesson[index].isCapital,
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
                  Image.asset('assets/images/components/selection-img.png')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
