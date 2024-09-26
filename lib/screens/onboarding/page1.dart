import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/onboarding/page1.png'), // Path to your background image
          fit: BoxFit.fill, // Ensures the image covers the entire background
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
                      'Welcome to',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'HandiLearn',
                      style: TextStyle(
                        fontSize: 44,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '''personalizes the learning experience for your child, 
making education fun and engaging.''',
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
