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
import 'package:test_drawing/screens/1).%20insideapp/5.%20progress/progressScreen.dart';
import 'package:test_drawing/screens/1).%20insideapp/home.dart';

class CategoryProgress extends StatefulWidget {
  CategoryProgress({
    required this.index,
    required this.categoryName,
    required this.categoryColor,
    required this.subCategoriesMinus,
    super.key,
  });

  final int index;
  final String categoryName;
  final int subCategoriesMinus;
  final Color categoryColor;

  @override
  State<CategoryProgress> createState() => _CategoryProgressState();
}

class _CategoryProgressState extends State<CategoryProgress> {
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    double spacer = MediaQuery.of(context).size.height * 0.02;
    String profileId = Provider.of<ProgressProvider>(context).profileId;
    String lessonId = Provider.of<ProgressProvider>(context).lessonId;
    int age = Provider.of<UserProvider>(context, listen: false).age;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => ProgressScreen(),
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
              image: AssetImage("assets/insideApp/progress/progressBg.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height * 0.05,
                right: 0,
                child: Image.asset(
                  height: 200,
                  width: 200,
                  'assets/insideApp/progress/progressImg.png',
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.22,
                left: MediaQuery.of(context).size.width * 0.05,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.categoryName} Progress",
                      style: GoogleFonts.poppins(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // CATEGORY PROGRESS
              Positioned(
                top: MediaQuery.of(context).size.height * 0.21,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: categoryList[widget.index].length -
                        widget.subCategoriesMinus,
                    itemBuilder: (context, index) {
                      final progressProvider =
                          Provider.of<ProgressProvider>(context);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 5),
                        child: Card(
                          elevation: 4,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.19,
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Gap(spacer),
                                  Text(
                                    "${categoryNames[widget.index][index]}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 17,
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
                                  const Gap(30),
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
                                          //animation: true,
                                          animationDuration: 900,
                                          backgroundColor: Colors.grey.shade300,
                                          progressColor: widget.categoryColor,
                                          leading: Text('0%'),
                                          lineHeight: 17,
                                          barRadius: Radius.circular(10),
                                        );
                                      }

                                      if (!snapshot.hasData ||
                                          !snapshot.data!.exists) {
                                        return Center(
                                            child: Text(
                                                'Document does not exist'));
                                      }

                                      // Assuming categoryList[widget.index][index] is a valid key in the document
                                      String progress = snapshot.data![
                                          categoryList[widget.index][index]
                                              .name];
                                      double progressPercent =
                                          double.parse(progress) /
                                              categoryList[widget.index][index]
                                                  .total;

                                      return LinearPercentIndicator(
                                        percent: progressPercent,
                                        //animation: true,
                                        animationDuration: 900,
                                        backgroundColor: Colors.grey.shade300,
                                        progressColor: widget.categoryColor,
                                        leading: Text(
                                            '${(progressPercent * 100).toStringAsFixed(0)}%'),
                                        lineHeight: 17,
                                        barRadius: Radius.circular(10),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
