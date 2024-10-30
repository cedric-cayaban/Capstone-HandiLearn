import 'dart:math';
import 'package:flutter/material.dart';
import 'package:test_drawing/data/objects.dart';
import 'package:test_drawing/screens/insideapp/3.%20scanning/camera_screen.dart';
import 'package:test_drawing/screens/insideapp/home.dart';

class Randomize extends StatefulWidget {
  const Randomize({super.key});

  @override
  State<Randomize> createState() => _RandomizeState();
}

class _RandomizeState extends State<Randomize> {
  int _randomNumber = 0;

  void randomTheObjects() {
    setState(() {
      _randomNumber = Random().nextInt(10);
    });
    print(_randomNumber);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize:
                MainAxisSize.min, // Ensures the dialog takes minimal space
            children: [
              Image.asset(
                  'assets/insideApp/scanning/objects/$_randomNumber.png'),
            ],
          ),
          actions: [
            Container(
              child: Material(
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    pickedNum = _randomNumber;
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => CameraScreen()));
                  },
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF10E119), Color(0xFF18991E)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Let's find it",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Randomize'),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => Home(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 30,
            color: Colors.white,
          ),
          //replace with our own icon data.
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Center the column
        children: [
          Image.asset(
            'assets/insideApp/scanning/mysterybox.gif',
            width: double.infinity,
          ), // Space between the image and button
          ElevatedButton(
            onPressed: randomTheObjects,
            child: Text("Scan Objects"),
          ),
          SizedBox(height: 20), // Space between button and number display
          // Text(
          //   'Random Number: $_randomNumber', // Display the random number
          //   style: TextStyle(fontSize: 24), // Style the text
          // ),
        ],
      ),
    );
  }
}
