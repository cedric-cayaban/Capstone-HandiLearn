import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:test_drawing/provider/progress_provider.dart';
import 'package:test_drawing/provider/user_provider.dart';
import 'package:test_drawing/screens/1).%20insideapp/5.%20progress/categoryList.dart';
import 'package:test_drawing/screens/1).%20insideapp/5.%20progress/categoryProgress.dart';
import 'package:test_drawing/screens/1).%20insideapp/home.dart';

class ProgressScreen extends StatefulWidget {
  ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<String> categoryNames = [
    'Letters',
    'Words',
    'Numbers',
    'Cursive',
  ];

  List<Color> categoryColor = [
    Color(0xFFFFC107), // Bright Amber Yellow
    Color(0xFF00BFAE), // Bright Blue-Green (Teal)
    Color(0xFF2196F3), // Bright Blue
    Color(0xFFF44336), // Bright Red
  ];

  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    double spacer = MediaQuery.of(context).size.height * 0.02;
    String profileId = Provider.of<ProgressProvider>(context).profileId;
    String lessonId = Provider.of<ProgressProvider>(context).lessonId;
    int age = Provider.of<UserProvider>(context, listen: false).age;

    // Age-based category filtering
    List<int> accessibleCategories = [];
    List<int> subCategoriesMinus =
        []; // FOR MINUS IN THE LENGTH OF CATEGORYLIST[INDEX]
    if (age >= 2 && age <= 3) {
      accessibleCategories = [0]; // Letters
      subCategoriesMinus = [0, 0, 0, 0]; //
    } else if (age >= 4 && age <= 5) {
      accessibleCategories = [0, 1, 2]; // Letters, Words, Numbers
      subCategoriesMinus = [0, 1, 0, 0]; //
    } else if (age >= 6) {
      accessibleCategories = [0, 1, 2, 3]; // All categories
      subCategoriesMinus = [0, 0, 0, 0];
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => Home(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/insideApp/progress/progressBg.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height * 0.02,
                right: 0,
                child: Image.asset(
                  height: 200,
                  width: 200,
                  'assets/insideApp/progress/progressImg.png',
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.19,
                left: MediaQuery.of(context).size.width * 0.05,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress Tracking',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "View your child's Progress",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // TOTAL PROGRESS
              Positioned(
                top: MediaQuery.of(context).size.height * 0.26,
                child: Card(
                  elevation: 4,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.17,
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(spacer),
                          Text(
                            "Total Progress",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Divider(
                            color: Colors.grey,
                            thickness: 1,
                            endIndent: 0,
                            indent: 0,
                          ),
                          const Gap(15),
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
                                  backgroundColor: Colors.blueGrey.shade100,
                                  linearGradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFFFF00),
                                      Color(0xFF00FF00)
                                    ],
                                  ),
                                  leading: Text('0%'),
                                  lineHeight:
                                      MediaQuery.of(context).size.height *
                                          0.017,
                                  barRadius: Radius.circular(10),
                                ); // Loading indicator
                              }

                              if (!snapshot.hasData || !snapshot.data!.exists) {
                                return Center(
                                    child: Text('Document does not exist'));
                              }

                              double totalProgressValue = 0.0;
                              double totalExpectedValue = 0.0;

                              for (int categoryIndex = 0;
                                  categoryIndex < categoryList.length;
                                  categoryIndex++) {
                                double categoryProgressValue = 0.0;
                                double categoryExpectedValue = 0.0;

                                for (int progressItem = 0;
                                    progressItem <
                                        categoryList[categoryIndex].length -
                                            subCategoriesMinus[categoryIndex];
                                    progressItem++) {
                                  double progress = double.parse(snapshot.data![
                                          categoryList[categoryIndex]
                                                  [progressItem]
                                              .name] ??
                                      '0');
                                  double total = categoryList[categoryIndex]
                                              [progressItem]
                                          .total ??
                                      0;
                                  categoryProgressValue += progress;
                                  categoryExpectedValue += total;
                                }

                                totalProgressValue += categoryProgressValue;
                                totalExpectedValue += categoryExpectedValue;
                              }

                              double totalProgress = totalExpectedValue == 0
                                  ? 0
                                  : totalProgressValue / totalExpectedValue;

                              return LinearPercentIndicator(
                                percent: totalProgress,
                                animation: true,
                                animationDuration: 900,
                                backgroundColor: Colors.grey.shade300,
                                linearGradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFFFF00),
                                    Color(0xFF00FF00)
                                  ],
                                ),
                                leading: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    '${(totalProgress * 100).toStringAsFixed(0)}%',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                lineHeight:
                                    MediaQuery.of(context).size.height * 0.017,
                                barRadius: Radius.circular(20),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // CATEGORY PROGRESS
              Positioned(
                top: MediaQuery.of(context).size.height * 0.45,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.50,
                  width: MediaQuery.of(context).size.width,
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    padding: const EdgeInsets.all(20),
                    children: List.generate(
                      4,
                      (index) {
                        // Check if the category is accessible based on age
                        bool isAccessible =
                            accessibleCategories.contains(index);

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: isAccessible
                                  ? () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CategoryProgress(
                                            index: index,
                                            categoryName: categoryNames[index],
                                            categoryColor: categoryColor[index],
                                            subCategoriesMinus:
                                                subCategoriesMinus[index],
                                          ),
                                        ),
                                      );
                                    }
                                  : null, // Disable tap if not accessible
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
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
                                        return CircularPercentIndicator(
                                          percent: 0,
                                          animation: true,
                                          animationDuration: 900,
                                          radius: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.09,
                                          lineWidth: 13,
                                          center: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.07,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Gap(12),
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 8),
                                                  child: Text(
                                                    '0%',
                                                    style: TextStyle(
                                                      fontSize: 26,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  categoryNames[index],
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.blueGrey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          progressColor: categoryColor[index],
                                          backgroundColor:
                                              Colors.blueGrey.shade100,
                                          circularStrokeCap:
                                              CircularStrokeCap.round,
                                        );
                                      }

                                      if (!snapshot.hasData ||
                                          !snapshot.data!.exists) {
                                        return Center(
                                            child: Text(
                                                'Document does not exist'));
                                      }

                                      double categoryProgressValue = 0.0;
                                      double categoryExpectedValue = 0.0;

                                      for (int progressItem = 0;
                                          progressItem <
                                              (categoryList[index].length -
                                                  subCategoriesMinus[index]);
                                          progressItem++) {
                                        double progress = double.parse(
                                            snapshot.data![categoryList[index]
                                                        [progressItem]
                                                    .name] ??
                                                '0');
                                        double total = categoryList[index]
                                                    [progressItem]
                                                .total ??
                                            0;
                                        categoryProgressValue += progress;
                                        categoryExpectedValue += total;
                                      }

                                      double categoryProgress =
                                          categoryExpectedValue == 0
                                              ? 0
                                              : categoryProgressValue /
                                                  categoryExpectedValue;

                                      return CircularPercentIndicator(
                                        percent: categoryProgress,
                                        animation: true,
                                        animationDuration: 900,
                                        radius:
                                            MediaQuery.of(context).size.height *
                                                0.09,
                                        lineWidth: 13,
                                        center: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.07,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Gap(12),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8),
                                                child: Text(
                                                  '${(categoryProgress * 100).toStringAsFixed(0)}%',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                categoryNames[index],
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      Colors.blueGrey.shade900,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        progressColor: categoryColor[index],
                                        backgroundColor:
                                            Colors.blueGrey.shade100,
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                      );
                                    },
                                  ),
                                  // Dark overlay for inaccessible categories
                                  if (!isAccessible)
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.black.withOpacity(0.4),
                                        ),
                                      ),
                                    ),
                                  if (!isAccessible)
                                    Image.asset('assets/insideApp/padlock.png')
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
