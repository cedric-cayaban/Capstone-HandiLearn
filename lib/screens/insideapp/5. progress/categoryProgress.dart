import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:test_drawing/screens/insideapp/5.%20progress/progressScreen.dart';
import 'package:test_drawing/screens/insideapp/home.dart';

class CategoryProgress extends StatefulWidget {
  const CategoryProgress({super.key});

  @override
  State<CategoryProgress> createState() => _CategoryProgressState();
}

class _CategoryProgressState extends State<CategoryProgress> {
  @override
  Widget build(BuildContext context) {
    double spacer = MediaQuery.of(context).size.height * 0.02;

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
                top: MediaQuery.of(context).size.height * 0.21,
                left: MediaQuery.of(context).size.width * 0.05,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category Name',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
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
                    itemCount: 3,
                    itemBuilder: (context, index) => Padding(
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
                                  "Total Progress",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
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
                                LinearPercentIndicator(
                                  percent: 0.45,
                                  animation: true,
                                  animationDuration: 900,
                                  backgroundColor: Colors.grey.shade300,
                                  linearGradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFFFF00),
                                      Color(0xFF00FF00),
                                    ],
                                  ),
                                  leading: Text('%'),
                                  lineHeight: 17,
                                  barRadius: Radius.circular(10),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
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
