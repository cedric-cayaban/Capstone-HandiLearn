import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:test_drawing/data/lessons.dart';
import 'package:test_drawing/objects/lesson.dart';
import 'package:test_drawing/home/learn/character_selection.dart';

class ActivityScreen extends StatefulWidget {
  ActivityScreen(
      {super.key,
      required this.lesson,
      required this.lessonTitle,
      required this.lessonNumber});

  String lessonTitle;
  List<Lesson> lesson;
  int lessonNumber;
  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

List<String> activityNames = [
  'Pronounce',
  'Write',
  'Mini Game',
];

class _ActivityScreenState extends State<ActivityScreen> {
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
                  'assets/images/components/activity-visual${widget.lessonNumber + 1}.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.10,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Centers content vertically
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Centers content horizontally
                  children: [
                    Text(
                      'Lesson ${widget.lessonNumber + 1}',
                      style: TextStyle(
                        color:
                            widget.lessonNumber == 3 || widget.lessonNumber == 6
                                ? Colors.white
                                : Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      widget.lessonTitle,
                      style: TextStyle(
                        color:
                            widget.lessonNumber == 3 || widget.lessonNumber == 6
                                ? Colors.white
                                : Colors.black87,
                        fontSize: 45,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
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
                      : Colors.black87,
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
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 20, top: 10, bottom: 15),
                        child: Text(
                          "Let's Learn",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: activityNames.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CharacterSelectionScreen(
                                    lesson: widget.lesson,
                                    activity: activityNames[index],
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16.0,
                              ),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/components/activity${index + 1}-bg.png'),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                height: 125,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        // Wrap the entire column to ensure it doesn't overflow
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              // Allows text to wrap if it overflows
                                              child: Text(
                                                'Lesson ${index + 1}:',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                softWrap: true,
                                                overflow: TextOverflow.visible,
                                              ),
                                            ),
                                            const Gap(15),
                                            Flexible(
                                              // Allows the lesson name to wrap if it's too long
                                              child: Text(
                                                activityNames[index],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        index >= 4 ? 27 : 30,
                                                    fontWeight: FontWeight.w500,
                                                    height: 1),
                                                softWrap: true,
                                                overflow: TextOverflow.visible,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Image.asset(
                                          'assets/images/components/activity${index + 1}-img.png'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
