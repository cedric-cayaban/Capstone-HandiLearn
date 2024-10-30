import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:test_drawing/screens/insideapp/1.%20learn/lesson_screen.dart';

import 'package:test_drawing/screens/insideapp/3.%20scanning/camera_screen.dart';
import 'package:test_drawing/screens/insideapp/2.%20short%20stories/selections.dart';
import 'package:test_drawing/screens/insideapp/3.%20scanning/instruction.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/chooseGame.dart';
import 'package:test_drawing/screens/insideapp/5.%20progress/progressScreen.dart';
import 'package:test_drawing/screens/useraccount/choose_profile.dart';

import '../../data/userAccount.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    print(LastActivity);
  }

  void getData() async {
    print(id);
    User user = FirebaseAuth.instance.currentUser!;
    String _uid = user.uid;
    final DocumentSnapshot profileDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection('profiles')
        .doc(id)
        .get();
    // print(profileDoc.get('age'));
    name = profileDoc.get('name');
    print(name);

    final DocumentSnapshot ageDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection('profiles')
        .doc(id)
        .get();
    age = int.parse(profileDoc.get('age'));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    //double spacer = MediaQuery.of(context).size.height * 0.1;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const ChooseProfile(),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/loginRegister/bg4.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height * 0.05,
                child: Column(
                  children: [
                    Text(
                      'Welcome, $name',
                      style: const TextStyle(fontSize: 24),
                    ),
                    Image.asset(
                      height: 180,
                      'assets/loginRegister/verified.png',
                    )
                  ],
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.28,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.77,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 2, // Spread radius
                        blurRadius: 7, // Blur radius
                        offset: const Offset(
                            0, 3), // Changes the position of the shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Progress',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const Gap(5),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => ProgressScreen(),
                            ));
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/insideApp/learnWriting/components/lesson${int.parse(LastActivity) + 1}-bg.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10),
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
                                              'Lesson ${int.parse(LastActivity) + 1}:',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                          Flexible(
                                            // Allows the lesson name to wrap if it's too long
                                            child: Text(
                                              lessonNames[
                                                  int.parse(LastActivity)],
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1),
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Image.asset(
                                      'assets/insideApp/learnWriting/components/lesson${int.parse(LastActivity) + 1}-img.png',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: const Text(
                        'Activities',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    const Gap(5),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => const LessonScreen(),
                                    ),
                                  );
                                },
                                child: const Column(
                                  children: [
                                    PhysicalModel(
                                      color: Colors.transparent,
                                      elevation:
                                          8.0, // Adjust elevation as needed
                                      shape: BoxShape.circle,
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/insideApp/learn.png'),
                                        radius: 60,
                                      ),
                                    ),
                                    Gap(10),
                                    Text('Learn')
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (_) => const Instruction(),
                                        ),
                                      );
                                    },
                                    child: const PhysicalModel(
                                      color: Colors.transparent,
                                      elevation:
                                          8.0, // Adjust elevation as needed
                                      shape: BoxShape.circle,
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/insideApp/scan.png'),
                                        radius: 60,
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                  const Text('Scan')
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              ShortStoriesSelection(),
                                        ),
                                      );
                                    },
                                    child: const PhysicalModel(
                                      color: Colors.transparent,
                                      elevation:
                                          8.0, // Adjust elevation as needed
                                      shape: BoxShape.circle,
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/insideApp/stories.png'),
                                        radius: 60,
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                  const Text('Short Stories')
                                ],
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (_) => Games(),
                                        ),
                                      );
                                    },
                                    child: const PhysicalModel(
                                      color: Colors.transparent,
                                      elevation:
                                          8.0, // Adjust elevation as needed
                                      shape: BoxShape.circle,
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/insideApp/games.png'),
                                        radius: 60,
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                  const Text('Mini Games')
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
