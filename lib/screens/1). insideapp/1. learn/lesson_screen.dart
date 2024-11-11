import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:test_drawing/data/lessons.dart';
import 'package:test_drawing/data/userAccount.dart';
import 'package:test_drawing/objects/lesson.dart';
import 'package:test_drawing/provider/user_provider.dart';
import 'package:test_drawing/screens/1).%20insideapp/1.%20learn/activity_screen.dart';
import 'package:test_drawing/screens/1).%20insideapp/1.%20learn/character_selection.dart';

import '../home.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

List<String> lessonNames = [
  'Capital Letters',
  'Small Letters',
  'Words',
  'Numbers',
  'Capital Cursives',
  'Small Cursives',
  'Cursive Words'
];

class _LessonScreenState extends State<LessonScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

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
                  'assets/insideApp/learnWriting/components/lesson-visual.png',
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
                children: [
                  Text(
                    'Learn',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Read and Write',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              left: 10,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => Home(),
                    ),
                  );
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
                        padding: EdgeInsets.only(
                          left: 20,
                          top: 10,
                          bottom: 15,
                        ),
                        child: Text(
                          'Choose your lesson',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: lessonNames.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: (userProvider.age == 2 && index >= 2) ||
                                    (userProvider.age == 3 && index >= 2) ||
                                    (userProvider.age == 4 && index >= 4) ||
                                    (userProvider.age == 5 &&
                                        index >=
                                            4) // Only allow click if unlocked
                                ? null
                                : () {
                                    print(lessonNames[index]);
                                    if (index == 0 || index == 2 || index == 3
                                        // || index == 4
                                        ) {
                                      LastActivity = index.toString();
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ActivityScreen(
                                            lesson: lessonData[index],
                                            lessonTitle: lessonNames[index],
                                            lessonNumber: index,
                                          ),
                                        ),
                                      );
                                    } else {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CharacterSelectionScreen(
                                            lesson: lessonData[index],
                                            lessonTitle: lessonNames[index],
                                            activity: 'Write',
                                            lessonNumber: index,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16.0,
                              ),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                height: 125,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    // Lesson background image
                                    Opacity(
                                      opacity: (userProvider.age == 2 &&
                                                  index >= 2) ||
                                              (userProvider.age == 3 &&
                                                  index >= 2) ||
                                              (userProvider.age == 4 &&
                                                  index >= 4) ||
                                              (userProvider.age == 5 &&
                                                  index >= 4)
                                          ? 0.5
                                          : 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                              'assets/insideApp/learnWriting/components/lesson${index + 1}-bg.png',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Other contents like text and lesson image
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, left: 20, right: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    'Lesson ${index + 1}:',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    softWrap: true,
                                                    overflow:
                                                        TextOverflow.visible,
                                                  ),
                                                ),
                                                const Gap(15),
                                                Flexible(
                                                  child: Text(
                                                    lessonNames[index],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: (index == 0 ||
                                                              index == 1 ||
                                                              index == 4 ||
                                                              index == 5 ||
                                                              index == 6)
                                                          ? 25
                                                          : 30,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 1,
                                                    ),
                                                    softWrap: true,
                                                    overflow:
                                                        TextOverflow.visible,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Image.asset(
                                            height: 80,
                                            width: 80,
                                            'assets/insideApp/learnWriting/components/lesson${index + 1}-img.png',
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Lock overlay, only if lesson is locked (index > age)
                                    if ((userProvider.age == 2 && index >= 2) ||
                                        (userProvider.age == 3 && index >= 2) ||
                                        (userProvider.age == 4 && index >= 4) ||
                                        (userProvider.age == 5 && index >= 4))
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                                0.5), // Dim the lesson image
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                          ),
                                          child: Center(
                                            child: Image.asset(
                                              'assets/insideApp/padlock.png', // Your locked image asset
                                              width: double
                                                  .infinity, // Adjust size as needed
                                              height: double.infinity,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
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
