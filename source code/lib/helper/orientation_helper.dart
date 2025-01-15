import 'package:flutter/services.dart';

class OrientationHelper {
  // Set screen orientation to portrait
  static Future<void> setPortrait() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // Set screen orientation to landscape
  static Future<void> setLandscape() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  // Reset to system default orientation
  static Future<void> resetOrientation() async {
    await SystemChrome.setPreferredOrientations([]);
  }
}
