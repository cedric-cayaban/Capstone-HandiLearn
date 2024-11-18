import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_drawing/screens/2.)%20onboarding/onboarding.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/onboarding/splashScreen.png', // Path to your background image
              fit: BoxFit.cover, // Ensures the image covers the entire screen
            ),
          ),
          // Splash Screen
          AnimatedSplashScreen(
            splash: null,
            nextScreen: OnBoarding(),
            splashIconSize: 400,
            animationDuration: Durations.short2,
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor:
                Colors.transparent, // Make the splash background transparent
          ),
        ],
      ),
    );
  }
}
