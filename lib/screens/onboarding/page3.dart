import 'package:flutter/material.dart';

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/onboarding/page3.png'),
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
                      'Teach Childrens',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Writing',
                      style: TextStyle(
                        fontSize: 44,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '''Lessons include tracing patterns for letters, numbers, 
and words. Handwriting recognition provides instant 
feedback and a 3-star rating system.''',
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
