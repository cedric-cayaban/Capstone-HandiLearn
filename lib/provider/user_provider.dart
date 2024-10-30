import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_drawing/data/userAccount.dart';

class UserProvider extends ChangeNotifier {
  String name = "";
  int age = 0;
  String pin = "";
  Future<void> fetchUserData() async {
    User user = FirebaseAuth.instance.currentUser!;
    final DocumentSnapshot profileDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('profiles')
        .doc(id)
        .get();
    name = profileDoc.get('name');
    age = int.parse(profileDoc.get('age'));
    pin = profileDoc.get('pin');
    notifyListeners();
  }
}
