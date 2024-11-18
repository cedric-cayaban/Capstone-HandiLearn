import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class WordSearchTip1 extends StatelessWidget {
  const WordSearchTip1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Search the words',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 25,
          ),
        ),
        Gap(20),
        Image.asset('assets/insideApp/games/word search/tip1.png'),
        Gap(20),
        Text(
          '1.) Search for the words located at the bottom part of the screen to complete the game',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 18.2,
          ),
        ),
      ],
    );
  }
}

class WordSearchTip2 extends StatelessWidget {
  const WordSearchTip2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Swipe the word',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 25,
          ),
        ),
        Gap(20),
        Image.asset('assets/insideApp/games/word search/tip2.gif'),
        Gap(20),
        Text(
          '1). Swipe the words that you will find in the board using your finger\n\n'
          '2). Let go of your finger once you are finished swiping',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 17.2,
          ),
        ),
      ],
    );
  }
}

class WordSearchTip3 extends StatelessWidget {
  const WordSearchTip3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Look carefully!',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 25,
          ),
        ),
        Gap(40),
        Image.asset('assets/insideApp/games/word search/tip3.png'),
        Gap(40),
        Text(
          '1.) There are some words that overlap with other words, so look carefully young learner!!',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
