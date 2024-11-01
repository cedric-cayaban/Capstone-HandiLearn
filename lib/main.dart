import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_drawing/auth/main_page.dart';
import 'package:test_drawing/firebase_options.dart';
import 'package:test_drawing/provider/lesson_provider.dart';
import 'package:test_drawing/provider/progress_provider.dart';
import 'package:test_drawing/provider/user_provider.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  cameras = await availableCameras();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LessonProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
      ],
      child: HandiLearn(),
    ),
  );
}

class HandiLearn extends StatelessWidget {
  const HandiLearn({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
