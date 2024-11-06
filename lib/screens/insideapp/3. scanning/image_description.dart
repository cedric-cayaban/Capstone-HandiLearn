import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'dart:math';

import 'package:test_drawing/screens/insideapp/home.dart';
import 'package:test_drawing/screens/insideapp/3.%20scanning/camera_screen.dart';

import '../../../data/objects.dart';

class ObjectDescription extends StatefulWidget {
  ObjectDescription(this.file, this.label, this.confidence, this.pickedImage,
      {super.key});
  File pickedImage;
  XFile file;
  var label;
  var confidence;

  @override
  State<ObjectDescription> createState() => _ObjectDescriptionState();
}

class _ObjectDescriptionState extends State<ObjectDescription> {
  // String _uid = '';
  // String _name = '';
  int randomNum = 0;

  @override
  Widget build(BuildContext context) {
    File pickedImage = File(widget.pickedImage.path);
    // String label = widget.label;
    int object = 0;
    String url;

    List<String> labels = [
      'BAG',
      'BOOK',
      'CHAIR',
      'RULER',
      'PENCIL',
      'NOTEBOOK',
      'CRAYONS',
      'ERASER',
      'SHOES',
      'SCISSORS'
    ];

    int random() {
      Random random = new Random();
      int randomNumber = random.nextInt(10000);

      return randomNumber;
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (_) => Home(),
                ),
              );
            },
            icon: const Icon(
              Icons.home,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/insideApp/scanning/bgDesc.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            // Gap(80),
            Positioned(
              top: 60,
              child: Container(
                height: 500,
                width: 351,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  // border: Border.all(color: Colors.black)
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 2, // Spread radius
                      blurRadius: 7, // Blur radius
                      offset:
                          Offset(0, 3), // Changes the position of the shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'This item is a',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(),
                      Text(
                        widget.label,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        // decoration: BoxDecoration(
                        //   border: Border.all(
                        //       color: const Color(0xFF89CFF3), width: 4),
                        // ),
                        height: 210,
                        width: 115,
                        child: Image.file(
                          pickedImage,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Gap(10),
                      Text(
                        textAlign: TextAlign.center,
                        objectData[object]['description'].toString(),
                        style: TextStyle(fontSize: 14),
                      ),
                      Gap(50),
                      Container(
                        width: double
                            .infinity, // Make the button fill the available width
                        child: Material(
                          borderRadius: BorderRadius.circular(
                              10), // Set your desired border radius here
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                                10), // Ensure the ripple effect respects the border radius
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => CameraScreen(),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity, // Expand to full width
                              height: 45, // Fixed height
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF10E119),
                                    Color(0xFF18991E)
                                  ], // Define your gradient colors
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(
                                    10), // Set the same border radius as above
                              ),
                              child: const Text(
                                'Scan again',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Image.asset(
                'assets/insideApp/scanning/mascot.png',
                height: 200,
                width: 200,
              ),
            )
          ],
        ),
      ),
    );
  }
}
