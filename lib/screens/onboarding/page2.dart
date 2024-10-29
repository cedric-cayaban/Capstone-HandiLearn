import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // Positioned(
          //   bottom: 0,
          //   child: Image.asset(
          //     'assets/onboarding/moving car.gif',
          //     height: 340,
          //     width: MediaQuery.sizeOf(context).width,
          //     fit: BoxFit.fill,
          //   ),
          // ),
          // Positioned(
          //   top: 0,
          //   child: Image.asset(
          //     'assets/onboarding/bg.png',
          //     height: MediaQuery.of(context).size.height * .80,
          //     width: MediaQuery.of(context).size.width,
          //     fit: BoxFit.fill,
          //   ),
          // ),
          // Positioned(
          //   top: 0,
          //   child: Image.asset(
          //     'assets/onboarding/clouds.gif',
          //     height: 340,
          //     width: MediaQuery.sizeOf(context).width,
          //     fit: BoxFit.fill,
          //   ),
          // ),
          Positioned(
            top: 70,
            right: 40,
            child: Image.asset(
              'assets/onboarding/page2.png',
              height: MediaQuery.of(context).size.height * .35,
              width: MediaQuery.of(context).size.width * .80,
              fit: BoxFit.fill,
            ),
          ),
          // Positioned(
          //   bottom: MediaQuery.of(context).size.height * 0.25,
          //   left: MediaQuery.of(context).size.width * 0.30,
          //   child: Image.asset(
          //     'assets/onboarding/dancing abc.gif',
          //     height: 60,
          //     width: MediaQuery.of(context).size.width * 0.30,
          //     fit: BoxFit.fill,
          //   ),
          // ),
          Positioned(
            bottom: MediaQuery.of(context).size.width * 0.65,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Aligns the text to the left
                children: [
                  Text(
                    'Create and Manage',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    'Multiple Profiles',
                    style: GoogleFonts.lora(
                      fontSize: 44,
                      fontWeight: FontWeight.normal,
                      height: 1.0,
                    ),
                  ),
                  Gap(10),
                  Text(
                    '''Track individual progress and 
personalize learning experiences.''',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
