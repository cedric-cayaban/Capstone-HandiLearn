import 'package:flutter/material.dart';

class Page7 extends StatelessWidget {
  const Page7({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/onboarding/page7.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Stack(
            children: [
              Positioned(
                bottom: 180,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Aligns the text to the left
                  children: [
                    Text(
                      'All',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 44,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '''Start creating profiles and exploring lessons to 
kickstart your child's personalized learning journey.''',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
