import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:test_drawing/screens/insideapp/1.%20learn/lesson_screen.dart';

import 'package:test_drawing/screens/insideapp/3.%20scanning/camera_screen.dart';
import 'package:test_drawing/screens/insideapp/2.%20short%20stories/selections.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/chooseGame.dart';
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => ChooseProfile(),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/loginRegister/bg4.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Gap(100),
              Text(
                'Welcome, ${name}',
                style: TextStyle(fontSize: 24),
              ),
              Gap(100),
              Container(
                width: 300,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 2, // Spread radius
                      blurRadius: 7, // Blur radius
                      offset:
                          Offset(0, 3), // Changes the position of the shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Continue...',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Gap(5),
                      LastActivity != ""
                          ? InkWell(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => LessonScreen(),
                                  ),
                                );
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
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                              ),
                                              const Gap(15),
                                              Flexible(
                                                // Allows the lesson name to wrap if it's too long
                                                child: Text(
                                                  lessonNames[
                                                      int.parse(LastActivity)],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 1),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.visible,
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
                          : Center(child: CircularProgressIndicator())
                    ],
                  ),
                ),
              ),
              const Gap(20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Activities'),
                  Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
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
                                    builder: (_) => LessonScreen(),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/insideApp/learn.png'),
                                    radius: 50,
                                  ),
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
                                        builder: (_) => CameraScreen(),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/insideApp/scan.png'),
                                    radius: 50,
                                  ),
                                ),
                                Text('Scan')
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
                                        builder: (_) => ShortStoriesSelection(),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/insideApp/stories.png'),
                                    radius: 50,
                                  ),
                                ),
                                Text('Short Stories')
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
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/insideApp/games.png'),
                                    radius: 50,
                                  ),
                                ),
                                Text('Mini Games')
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
