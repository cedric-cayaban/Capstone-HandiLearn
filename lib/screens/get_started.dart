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
      body: AnimatedSplashScreen(
        splash: 'assets/onboarding/logo.png',
        nextScreen: OnBoarding(),
        splashIconSize: 400,
        animationDuration: Durations.short2,
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Color(0xFF3FE546),
      ),
    );
  }
}
