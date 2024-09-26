import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:test_drawing/screens/useraccount/choose_profile.dart';
import 'package:test_drawing/screens/useraccount/set_pin.dart';

import '../../data/userAccount.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool? ischecked = false;
  DateTime selectedDate = DateTime.now();
  int age = 2;
  int selectedIndex = -1;
  int selectedAvatar = -1;
  final TextEditingController nameController = TextEditingController();
  String name = '';

  void saveProfile() async {
    // print('$selectedAvatar, $selectedIndex');
    final User? user = _auth.currentUser;
    final _uid = user?.uid;
    if (selectedAvatar != -1 &&
        selectedIndex != -1 &&
        nameController.text != "") {
      try {
        // await FirebaseFirestore.instance
        //     .collection('users')
        //     .doc(_uid)
        //     .collection('profiles')
        //     .add({
        //   'profile id': _uid,
        //   'name': nameController.text,
        //   'age': selectedIndex + 2,
        //   'avatar': selectedAvatar + 1,

        //   // 'password': profilePass.text.hashCode,
        // });
        ProfileData profileData = ProfileData(
            id: 'top',
            parentId: _uid!,
            name: nameController.text,
            age: (selectedIndex + 2).toString(),
            avatar: (selectedAvatar + 1).toString(),
            pin: '');
        // print((selectedIndex + 2).toString() +
        //     "," +
        //     (selectedAvatar + 1).toString());
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => SetPin(profileData: profileData),
          ),
        );
      } catch (error) {
        print(error);
      }
    } else {
      print('Provide all inputs');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.addListener(() {
      setState(() {
        print(name);
        name = nameController.text; // Update the name variable
      });
    });
  }

  @override
  void dispose() {
    nameController
        .dispose(); // Clean up the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Create Profile',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => ChooseProfile(),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_back_ios)),
          actions: [
            IconButton(
              onPressed: null,
              icon: Icon(
                Icons.person,
              ),
            ),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/loginRegister/bg4.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(21.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Gap(42),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        // Border width
                        ),
                  ),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: selectedAvatar != -1
                        ? AssetImage(
                            'assets/loginRegister/avatars/${selectedAvatar + 1}.png')
                        : AssetImage(
                            'assets/loginRegister/avatars/1.png'), // Use image assets
                  ),
                ),
                Gap(5),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: 150,
                  height: 30,
                  child: Text(
                    textAlign: TextAlign.center,
                    name.isEmpty ? "Christopherson" : nameController.text,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Gap(60),
                Container(
                  height: MediaQuery.of(context).size.height * 0.60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    // border: Border.all(color: Colors.black),
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
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("What is your child's name"),
                        TextField(
                          controller: nameController, // Set the controller
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                            hintText: 'Christopherson',
                          ),
                        ),
                        Text("What is your child's age"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(5, (index) {
                            int displayNumber = index + 2; // Start from 2
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                  print(selectedIndex);
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: selectedIndex == index
                                    ? Colors.blue
                                    : Colors.white,
                                child: Text(
                                    '$displayNumber'), // Display the number
                              ),
                            );
                          }),
                        ),
                        Text("Select an avatar"),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(3, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedAvatar = index;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: selectedAvatar == index
                                            ? Colors.blue
                                            : Colors.transparent,
                                        width: 2, // Border width
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 35,
                                      backgroundImage: AssetImage(
                                          'assets/loginRegister/avatars/${index + 1}.png'), // Use image assets
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(3, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedAvatar = index +
                                          3; // Adjust index for the second row
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: selectedAvatar == index + 3
                                            ? Colors.blue
                                            : Colors.transparent,
                                        width: 2, // Border width
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 35,
                                      backgroundImage: AssetImage(
                                          'assets/loginRegister/avatars/${index + 4}.png'), // Use image assets
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                        Gap(10),
                        Container(
                          width: double
                              .infinity, // Make the button fill the available width
                          child: Material(
                            borderRadius: BorderRadius.circular(
                                10), // Set your desired border radius here
                            child: InkWell(
                              borderRadius: BorderRadius.circular(
                                  10), // Ensure the ripple effect respects the border radius
                              onTap: saveProfile,
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
                                  'Save',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
