import 'package:flutter/material.dart';

class ProgressProvider with ChangeNotifier {
  String _profileId = "";
  String _lessonId = "";
  String get profileId => _profileId;
  String get lessonId => _lessonId;
  double _totalProgress = 0.0; // 

  void setProfileId(String id) {
    _profileId = id;
    notifyListeners();
  }

  void setLessonId(String id) {
    _lessonId = id;
    notifyListeners();
  }

   void setTotalProgress(double progress) {
    _totalProgress = progress;
    notifyListeners();
  }

  // List<double> getProgressByCategory(String category) {
  //   return _categoryProgress[category] ?? [];
  // }

  // void setProgressPercent(String category, int index, double value) {
  //   if (_categoryProgress.containsKey(category)) {
  //     if (index < _categoryProgress[category]!.length) {
  //       _categoryProgress[category]![index] = value;
  //     } else {
  //       _categoryProgress[category]!.add(value);
  //     }
  //     notifyListeners();
  //   }
  // }

  // void clearProgress() {
  //   _categoryProgress.forEach((key, value) {
  //     value.clear();
  //   });
  //   notifyListeners();
  // }
}
