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
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.37,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/images/components/lesson_visual.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.12,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Learn',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Read and Write',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
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
                            margin: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ), // Adding margin for better spacing
                            elevation: 4, // Adds a bit of shadow effect
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              title: Text(
                                lessonNames[index],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
