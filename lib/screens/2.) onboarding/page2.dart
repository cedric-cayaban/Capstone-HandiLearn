import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: Column(
          children: [
            Image.asset(
              'assets/onboarding/page2.png',
              height: 165,
              width: 200,
              fit: BoxFit.fill,
            ),
            const Gap(40),
            Padding(
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
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      height: 1.0,
                    ),
                  ),
                  const Gap(10),
                  Text(
                    'Multiple Profiles',
                    style: GoogleFonts.lora(
                      fontSize: 40,
                      fontWeight: FontWeight.normal,
                      height: 1.0,
                    ),
                  ),
                  Gap(20),
                  Text(
                    '''Track individual progress and personalize learning experiences.''',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
