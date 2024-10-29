import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class Page5 extends StatelessWidget {
  const Page5({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: Column(
          children: [
            Image.asset(
              'assets/onboarding/page5.png',
              height: 165,
              width: 150,
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
                    'Scan',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      height: 1.0,
                    ),
                  ),
                  const Gap(10),
                  Text(
                    'Objects',
                    style: GoogleFonts.lora(
                      fontSize: 44,
                      fontWeight: FontWeight.normal,
                      height: 1.0,
                    ),
                  ),
                  Gap(20),
                  Text(
                    '''A fun, interactive way to expand vocabulary and knowledge.''',
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
