import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: Column(
          children: [
            Image.asset(
              'assets/onboarding/logo.png',
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
                    'Welcome to',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      height: 1.0,
                    ),
                  ),
                  const Gap(10),
                  Text(
                    'HandiLearn',
                    style: GoogleFonts.lora(
                      fontSize: 44,
                      fontWeight: FontWeight.normal,
                      height: 1.0,
                    ),
                  ),
                  const Gap(20),
                  Text(
                    '''personalizes the learning experience for your child, making education fun and engaging.''',
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
