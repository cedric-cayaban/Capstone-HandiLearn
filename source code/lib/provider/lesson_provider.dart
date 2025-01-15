// lesson_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_drawing/data/userAccount.dart';

class LessonProvider extends ChangeNotifier {
  int ucharacterDone = 0;
  bool isListening = false;
  bool dialogShown = false;

  Future<void> fetchCharacterDone(String lessonField) async {
    print('natatawag sa provider');
    print('Dito lessonTitle: $lessonField');

    try {
      User user = FirebaseAuth.instance.currentUser!;
      String _uid = user.uid;
      final profileDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_uid)
          .collection('profiles')
          .doc(id) // replace with your profileId
          .collection("LessonsFinished")
          .doc(lessonid) // replace with your lessonId
          .get();

      ucharacterDone = int.parse(profileDoc.get("$lessonField"));
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateLesson(String lessonField, int characterDone) async {
    print('natatawag update sa provider');
    try {
      User user = FirebaseAuth.instance.currentUser!;
      String _uid = user.uid;

      // Assuming 'id' and 'lessonid' are defined elsewhere in your class
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_uid)
          .collection('profiles')
          .doc(id)
          .collection("LessonsFinished")
          .doc(lessonid)
          .update({"${lessonField}": "${ucharacterDone + 1}"});
      fetchCharacterDone(lessonField);
      notifyListeners();
    } catch (e) {
      print('Error updating lesson: $e'); // Handle error appropriately
    }
  }

  void updateDialogStatus(bool status) {
    dialogShown = status;
    notifyListeners();
  }

  void toggleListening(bool listening) {
    isListening = listening;
    notifyListeners();
  }
}
