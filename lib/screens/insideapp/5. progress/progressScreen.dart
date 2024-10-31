import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:test_drawing/screens/insideapp/5.%20progress/categoryProgress.dart';
import 'package:test_drawing/screens/insideapp/home.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
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
                    builder: (_) => Home(),
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
                      'Progress Tracking',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "View your child's Progress",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              // TOTAL PROGRESS
              Positioned(
                top: MediaQuery.of(context).size.height * 0.28,
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
                          const Gap(15),
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
              // CATEGORY PROGRESS
              Positioned(
                top: MediaQuery.of(context).size.height * 0.5,
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
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => CategoryProgress(),
                                  ),
                                );
                              },
                              child: CircularPercentIndicator(
                                percent: 0.25,
                                animation: true,
                                animationDuration: 900,
                                radius:
                                    MediaQuery.of(context).size.height * 0.09,
                                lineWidth: 13,
                                center: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius:
                                      MediaQuery.of(context).size.height * 0.07,
                                  child: Text(
                                    '25%',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                progressColor: Colors.red,
                                backgroundColor: Colors.grey.shade300,
                                circularStrokeCap: CircularStrokeCap.round,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
