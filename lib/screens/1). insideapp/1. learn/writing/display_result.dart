import 'dart:io';
import 'package:flutter/material.dart';
import 'package:test_drawing/screens/1).%20insideapp/home.dart';

class DisplayResult extends StatelessWidget {
  final String imagePath;
  final String label;

  const DisplayResult({
    Key? key,
    required this.imagePath,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recognition Result"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => Home(),
                  ),
                );
              },
              icon: Icon(Icons.house_rounded))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.file(
            File(imagePath),
            height: MediaQuery.of(context).size.height * .50,
            width: MediaQuery.of(context).size.height * .50,
          ),
          SizedBox(height: 20),
          Text(
            "$label",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
