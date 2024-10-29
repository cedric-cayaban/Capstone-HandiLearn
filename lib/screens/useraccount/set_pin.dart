import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:test_drawing/data/userAccount.dart';
import 'package:test_drawing/screens/useraccount/choose_profile.dart';
import 'package:test_drawing/screens/useraccount/create_profile.dart';

class SetPin extends StatefulWidget {
  final ProfileData profileData;

  const SetPin({Key? key, required this.profileData}) : super(key: key);

  @override
  State<SetPin> createState() => _SetPinState();
}

class _SetPinState extends State<SetPin> {
  String enteredPin = '';
  bool isPinVisible = false;
  String password = '1234';

  /// this widget will be use for each digit
  Widget numButton(int number) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
      child: TextButton(
        onPressed: () {
          setState(() {
            if (enteredPin.length < 4) {
              enteredPin += number.toString();
            }
          });
        },
        child: Text(
          number.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  void addProfile(String pin) async {
    print(pin);
    try {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.profileData.parentId)
          .collection('profiles')
          .add({
        'parent id': widget.profileData.parentId,
        'name': widget.profileData.name,
        'age': widget.profileData.age,
        'avatar': widget.profileData.avatar,
        'pin': pin,
      });

      String profileId = docRef.id;

      await docRef.update({
        'profile id': profileId,
      });

      addLessons(profileId, widget.profileData.age, docRef);
      print('success');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ChooseProfile(),
        ),
      );
    } catch (error) {
      print(error);
    }
  }

  void addLessons(
      String profileId, String age, DocumentReference addLessonId) async {
    // int profileAge = int.parse(age);
    // Original lesson data
    Map<String, String> lessonData = {
      "Capital Letters_Pronounce": "0",
      "Capital Letters_Write": "0",
      "Small Letters": "0",
      "Words_Pronounce": "0",
      "Words_Write": "0",
      "Numbers_Pronounce": "0",
      "Numbers_Write": "0",
      "Capital Cursives_Pronounce": "0",
      "Capital Cursives_Write": "0",
      "Small Cursives": "0",
      "Cursive Words": "0",
    };

// Map to hold the data to be added based on age
    Map<String, String> selectedData = {};

// Determine the number of items to add based on the age
    int itemsToAdd;
    if (age == "2") {
      itemsToAdd = 3;
    } else if (age == "3") {
      itemsToAdd = 5;
    } else if (age == "4") {
      itemsToAdd = 7;
    } else if (age == "5") {
      itemsToAdd = 9;
    } else {
      itemsToAdd = lessonData.length; // Add all items if age > 5
    }

// Select the specified number of items from lessonData
    selectedData = Map.fromEntries(lessonData.entries.take(itemsToAdd));

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentReference docRef = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('profiles')
            .doc(profileId)
            .collection('LessonsFinished')
            .add(selectedData);

        String lessonId = docRef.id;

        await addLessonId.update({
          'lesson id': lessonId,
        });
        print('Success sa pagaadd ng lessondata');
      } else {
        print("User is not logged in.");
      }
    } catch (error) {
      print("Failed to add document: $error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('Tanginaaaa');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => CreateProfile(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/loginRegister/bgPin.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 250,
            ),
            Container(
              height: 400,
              width: MediaQuery.of(context).size.width * 0.80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                // border: Border.all(color: Colors.black),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 7, // Blur radius
                    offset: Offset(0, 3), // Changes the position of the shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: Text(
                        'Set Your Pin',
                        style: TextStyle(
                            // fontSize: 32,
                            // color: Colors.black,
                            // fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    Gap(5),

                    /// pin code area
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        4,
                        (index) {
                          return Container(
                            margin: const EdgeInsets.all(6.0),
                            width: isPinVisible ? 30 : 20,
                            height: isPinVisible ? 30 : 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  isPinVisible ? 100.0 : 100),
                              color: index < enteredPin.length
                                  ? isPinVisible
                                      ? Colors.green
                                      : CupertinoColors.activeBlue
                                  : CupertinoColors.activeBlue.withOpacity(0.1),
                            ),
                            child: isPinVisible && index < enteredPin.length
                                ? Center(
                                    child: Text(
                                      enteredPin[index],
                                      style: const TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                : null,
                          );
                        },
                      ),
                    ),

                    /// visiblity toggle button
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isPinVisible = !isPinVisible;
                        });
                      },
                      icon: Icon(
                        isPinVisible ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),

                    // SizedBox(height: isPinVisible ? 50.0 : 8.0),

                    /// digits
                    for (var i = 0; i < 3; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            3,
                            (index) => numButton(1 + 3 * i + index),
                          ).toList(),
                        ),
                      ),

                    /// 0 digit with back remove
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TextButton(onPressed: null, child: SizedBox()),
                          numButton(0),
                          Gap(5),
                          TextButton(
                            onPressed: () {
                              setState(
                                () {
                                  if (enteredPin.isNotEmpty) {
                                    enteredPin = enteredPin.substring(
                                        0, enteredPin.length - 1);
                                  }
                                },
                              );
                            },
                            child: const Icon(
                              Icons.backspace,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// reset button
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
                            if (enteredPin.length == 4) {
                              addProfile(enteredPin);
                            }
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
                              'Enter',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
