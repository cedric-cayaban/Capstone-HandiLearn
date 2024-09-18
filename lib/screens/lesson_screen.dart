import 'package:flutter/material.dart';
import 'package:test_drawing/lists/lessons.dart';
import 'package:test_drawing/screens/character_selection.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

List<String> lessonNames = [
  'Lesson 1: Capital Letters',
  'Lesson 2: Small Letters',
  'Lesson 3: Words',
  'Lesson 4: Numbers',
  'Lesson 5: Cursive Capital Letters',
  'Lesson 6: Cursive Small Letters',
  'Lesson 7: Cursive Words'
];

class _LessonScreenState extends State<LessonScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Lessons"),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: lessonNames.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CharacterSelectionScreen(
                          lessonTitle: lessonNames[index],
                          lesson: lessonData[index],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(lessonNames[index]),
                    ),
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
