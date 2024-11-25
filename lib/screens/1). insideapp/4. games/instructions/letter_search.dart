import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class LetterSearchTip1 extends StatelessWidget {
  const LetterSearchTip1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      // Align content to the start
      children: [
        Text(
          'Lets find the Letter',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 23,
          ),
        ),
        Gap(20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/insideApp/games/letter search/tip1.png',
              width: 300, // Adjust image size to fit better
            ),
            Gap(20),
            Expanded(
              child: Text(
                '1.) There is a sign at the top center of the screen that shows what letter you need to find',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: MediaQuery.of(context).size.height * 0.05,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class LetterSearchTip2 extends StatelessWidget {
  const LetterSearchTip2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Click the Letter',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 26,
          ),
        ),
        const Gap(10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/insideApp/games/letter search/tip2.png',
              width: 300, // Adjust image size
            ),
            Gap(20),
            Expanded(
              child: Text(
                '1). Look around the screen! There are letters placed throughout the screen\n\n'
                '2). Tap the letter that is on the sign on the top of the screen',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: MediaQuery.of(context).size.height * 0.041,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class LetterSearchTip3 extends StatelessWidget {
  const LetterSearchTip3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Find all letters',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 26,
          ),
        ),
        Gap(10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/insideApp/games/letter search/tip3.png',
              width: 300, // Adjust image size
            ),
            Gap(30),
            Expanded(
              child: Text(
                '1.) Find all the letters that is needed at the bottom right of the screen to complete the game!!',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: MediaQuery.of(context).size.height * 0.05,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
