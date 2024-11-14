
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_drawing/screens/get_started.dart';
import 'package:test_drawing/screens/3).%20useraccount/choose_profile.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ChooseProfile();
          } else {
            return GetStarted();
          }
        },
      ),
    );
  }
}
