import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:test_drawing/provider/progress_provider.dart';
import 'package:test_drawing/provider/user_provider.dart';
import 'package:test_drawing/screens/insideapp/1.%20learn/lesson_screen.dart';

import 'package:test_drawing/screens/insideapp/3.%20scanning/camera_screen.dart';
import 'package:test_drawing/screens/insideapp/2.%20short%20stories/selections.dart';
import 'package:test_drawing/screens/insideapp/3.%20scanning/instruction.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/chooseGame.dart';
import 'package:test_drawing/screens/insideapp/5.%20progress/categoryList.dart';
import 'package:test_drawing/screens/insideapp/5.%20progress/progressScreen.dart';
import 'package:test_drawing/screens/useraccount/choose_profile.dart';

import '../../data/userAccount.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // String name = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // // getData();
    // print(LastActivity);
  }

  // void getData() async {
  //   print(id);
  //   User user = FirebaseAuth.instance.currentUser!;
  //   String _uid = user.uid;
  //   final DocumentSnapshot profileDoc = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(_uid)
  //       .collection('profiles')
  //       .doc(id)
  //       .get();
  //   // print(profileDoc.get('age'));
  //   name = profileDoc.get('name');
  //   print(name);

  //   final DocumentSnapshot ageDoc = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(_uid)
  //       .collection('profiles')
  //       .doc(id)
  //       .get();
  //   age = int.parse(profileDoc.get('age'));
  //   setState(() {});
  // }
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String avatarUrl = Provider.of<UserProvider>(context, listen: false).avatar;
    String profileId = Provider.of<ProgressProvider>(context).profileId;
    String lessonId = Provider.of<ProgressProvider>(context).lessonId;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    //double spacer = MediaQuery.of(context).size.height * 0.1;
    return SafeArea(
      child: Scaffold(
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
                top: 20,
                left: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const ChooseProfile(),
                      ),
                    );
                  },
                  child: Image.asset(
                      height: MediaQuery.of(context).size.height * 0.045,
                      "assets/insideApp/close.png"),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.05,
                child: Column(
                  children: [
                    Text(
                      'Welcome, ${userProvider.name}',
                      style: const TextStyle(
                        fontSize: 26,
                      ),
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
                  height: MediaQuery.of(context).size.height * 0.131,
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
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(5),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => ProgressScreen(),
                            ));
                          },
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            height: MediaQuery.of(context).size.height * 0.08,
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius:
                                      26, // Adjust size to match the image’s
                                  backgroundImage: AssetImage(
                                    'assets/loginRegister/avatars/$avatarUrl.png',
                                  ),
                                ),
                                const Gap(10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 12.0),
                                        child: Text(
                                          'Learn Progress',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const Gap(7),
                                      StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(userId)
                                            .collection('profiles')
                                            .doc(profileId)
                                            .collection('LessonsFinished')
                                            .doc(lessonId)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return LinearPercentIndicator(
                                              percent: 0,
                                              animation: true,
                                              animationDuration: 900,
                                              backgroundColor:
                                                  Colors.blueGrey.shade100,
                                              linearGradient:
                                                  const LinearGradient(
                                                colors: [
                                                  Color(
                                                      0xFFFFD700), // Adjust colors
                                                  Color(0xFF00FF00),
                                                ],
                                              ),
                                              lineHeight:
                                                  10, // Smaller height for a sleeker look
                                              barRadius:
                                                  const Radius.circular(5),
                                            );
                                          }

                                          if (!snapshot.hasData ||
                                              !snapshot.data!.exists) {
                                            return const Center(
                                              child: Text(
                                                  'Document does not exist'),
                                            );
                                          }

                                          double totalProgressValue = 0.0;
                                          double totalExpectedValue = 0.0;

                                          for (int categoryIndex = 0;
                                              categoryIndex <
                                                  categoryList.length;
                                              categoryIndex++) {
                                            double categoryProgressValue = 0.0;
                                            double categoryExpectedValue = 0.0;

                                            for (var progressItem
                                                in categoryList[
                                                    categoryIndex]) {
                                              double progress = double.parse(
                                                  snapshot.data![
                                                          progressItem.name] ??
                                                      '0');
                                              categoryProgressValue += progress;
                                              categoryExpectedValue +=
                                                  progressItem.total;
                                            }

                                            totalProgressValue +=
                                                categoryProgressValue;
                                            totalExpectedValue +=
                                                categoryExpectedValue;
                                          }

                                          double totalProgress =
                                              totalExpectedValue == 0
                                                  ? 0
                                                  : totalProgressValue /
                                                      totalExpectedValue;

                                          return LinearPercentIndicator(
                                            percent: totalProgress,
                                            animation: true,
                                            animationDuration: 900,
                                            backgroundColor:
                                                Colors.grey.shade300,
                                            linearGradient:
                                                const LinearGradient(
                                              colors: [
                                                Color(0xFFFFD700),
                                                Color(0xFF00FF00),
                                              ],
                                            ),
                                            lineHeight: 10,
                                            barRadius: const Radius.circular(5),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.46,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Activities',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
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
                                child: Column(
                                  children: [
                                    PhysicalModel(
                                      color: Colors.transparent,
                                      elevation:
                                          8.0, // Adjust elevation as needed
                                      shape: BoxShape.circle,
                                      child: CircleAvatar(
                                        backgroundImage: const AssetImage(
                                            'assets/insideApp/learn.png'),
                                        radius:
                                            MediaQuery.of(context).size.height *
                                                0.069,
                                      ),
                                    ),
                                    const Gap(10),
                                    const Text(
                                      'Learn',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    )
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
                                    child: PhysicalModel(
                                      color: Colors.transparent,
                                      elevation:
                                          8.0, // Adjust elevation as needed
                                      shape: BoxShape.circle,
                                      child: CircleAvatar(
                                        backgroundImage: const AssetImage(
                                            'assets/insideApp/scan.png'),
                                        radius:
                                            MediaQuery.of(context).size.height *
                                                0.069,
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                  const Text(
                                    'Scan',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  )
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
                                    child: PhysicalModel(
                                      color: Colors.transparent,
                                      elevation:
                                          8.0, // Adjust elevation as needed
                                      shape: BoxShape.circle,
                                      child: CircleAvatar(
                                        backgroundImage: const AssetImage(
                                            'assets/insideApp/stories.png'),
                                        radius:
                                            MediaQuery.of(context).size.height *
                                                0.069,
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                  const Text(
                                    'Short Stories',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  )
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
                                    child: PhysicalModel(
                                      color: Colors.transparent,
                                      elevation:
                                          8.0, // Adjust elevation as needed
                                      shape: BoxShape.circle,
                                      child: CircleAvatar(
                                        backgroundImage: const AssetImage(
                                            'assets/insideApp/games.png'),
                                        radius:
                                            MediaQuery.of(context).size.height *
                                                0.069,
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                  const Text(
                                    'Mini Games',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  )
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
