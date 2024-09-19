import 'package:flutter/material.dart';
import 'package:test_drawing/objects/lesson.dart';
import 'package:test_drawing/screens/drawing-board.dart';

class CharacterSelectionScreen extends StatefulWidget {
  CharacterSelectionScreen({
    super.key,
    required this.lesson,
    required this.lessonTitle,
    // required this.index,
    // required this.character,
    // required this.svgPath,
    // required this.type,
    // required this.isCapital,
  });
  String lessonTitle;
  List<Lesson> lesson;

  // int index;
  // String character;
  // String svgPath;
  // String type;
  // bool isCapital;

  @override
  State<CharacterSelectionScreen> createState() =>
      _LetterSelectionsScreenState();
}

class _LetterSelectionsScreenState extends State<CharacterSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.lessonTitle),
        ),
        body: Column(
          children: [
            Expanded(
                child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 1),
              itemCount: widget.lesson.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DrawingScreen(
                        type: widget.lesson[index].type,
                        svgPath: widget.lesson[index].svgPath,
                        character: widget.lesson[index].character,
                        isCapital: widget.lesson[index].isCapital),
                  ));
                },
                child: Card(
                  child: GridTile(
                    child: Text(widget.lesson[index].character),
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
