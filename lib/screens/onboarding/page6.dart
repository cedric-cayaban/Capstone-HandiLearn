import 'package:flutter/material.dart';

class Page6 extends StatelessWidget {
  const Page6({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/onboarding/page6.png'),
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
                      'Mini',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Games',
                      style: TextStyle(
                        fontSize: 44,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '''Play a game to practice everything you've learned.
Review and reinforce learning in an engaging and 
interactive way.''',
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
