import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class Page7 extends StatelessWidget {
  const Page7({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: Column(
          children: [
            Image.asset(
              'assets/onboarding/page7.png',
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
                    'All',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      height: 1.0,
                    ),
                  ),
                  const Gap(10),
                  Text(
                    'Done',
                    style: GoogleFonts.lora(
                      fontSize: 44,
                      fontWeight: FontWeight.normal,
                      height: 1.0,
                    ),
                  ),
                  Gap(20),
                  Text(
                    '''Start creating profiles and exploring lessons to kickstart your child's personalized learning journey.''',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
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
