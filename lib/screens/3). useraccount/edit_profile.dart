import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:test_drawing/screens/1).%20insideapp/5.%20progress/categoryList.dart';
import 'package:test_drawing/screens/1).%20insideapp/5.%20progress/progressScreen.dart';
import 'package:test_drawing/screens/3).%20useraccount/choose_profile.dart';
import 'package:test_drawing/screens/3).%20useraccount/parent_settings.dart';
import 'package:test_drawing/screens/3).%20useraccount/set_pin.dart';
import '../../data/userAccount.dart';

class EditProfile extends StatefulWidget {
  EditProfile({
    required this.name,
    required this.age,
    required this.avatar,
    required this.avatarImage,
    required this.profileId,
    required this.lessonId,
    required this.pin,
    super.key,
  });

  final String name;
  final String age;
  final String avatar;
  final String avatarImage;
  final String profileId;
  final String lessonId;
  final String pin;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool? ischecked = false;
  DateTime selectedDate = DateTime.now();
  int selectedIndex = -1;
  int selectedAvatar = -1;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  String name = '';
  String userId = FirebaseAuth.instance.currentUser!.uid;
  String avatar = "";
  String url = "";

  void updateProfile() async {
    print(selectedAvatar);
    // print(image);

    print(selectedIndex);

    print(nameController.text);

    if ((selectedAvatar != -1 || image != "") &&
        nameController.text != "" &&
        pinController.text != "" &&
        pinController.text.length == 4) {
      if (image != null) {
        final imageTemporary = File(image!.path);
        final User? user = _auth.currentUser;
        final _uid = user?.uid;

        String imageName = nameController.text + _uid!;

        final ref = FirebaseStorage.instance
            .ref()
            .child('profileImage')
            .child('$imageName.jpg');
        await ref.putFile(imageTemporary);

        url = await ref.getDownloadURL();
      }

      try {
        if (selectedAvatar == -1) {
          // Update the profile document in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId) // Ensure to have the parent user document reference
              .collection('profiles')
              .doc(
                  widget.profileId) // Use the profile ID to locate the document
              .update({
            'name': nameController.text,
            'pin': pinController.text,
            'age': (selectedIndex + 2).toString(),
            'avatar': "",
            'avatarImage': url,
          });
        } else {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId) // Ensure to have the parent user document reference
              .collection('profiles')
              .doc(
                  widget.profileId) // Use the profile ID to locate the document
              .update({
            'name': nameController.text,
            'pin': pinController.text,
            'age': (selectedIndex + 2).toString(),
            'avatar': (selectedAvatar + 1).toString(),
            'avatarImage': "",
          });
        }

        // Navigate back to the ChooseProfile screen or provide feedback
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => ParentSettings()),
        );
      } catch (error) {
        print('Error updating profile: $error');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill up all the requirements"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  File? image;

  Future<void> _pickedImageGallery() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        print('pask pickedfile');
        image = File(pickedFile.path);
        selectedAvatar = -1;
        setState(() {});
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }

    print('nakakapask');
    print(selectedAvatar);
    print(image);
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name;
    pinController.text = widget.pin;
    name = widget.name;
    avatar = widget.avatarImage;

    // Initialize selectedIndex based on the age
    selectedIndex =
        int.tryParse(widget.age) != null ? int.parse(widget.age) - 2 : -1;

    // Initialize selectedAvatar based on the avatar string
    selectedAvatar =
        int.tryParse(widget.avatar) != null ? int.parse(widget.avatar) - 1 : -1;

    nameController.addListener(() {
      setState(() {
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
    double spacer = MediaQuery.of(context).size.height * 0.04;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/loginRegister/bg4.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: spacer, left: 21, right: 21),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(),
                            ),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundImage: image != null &&
                                      selectedAvatar == -1
                                  ? FileImage(image!) as ImageProvider
                                  : (selectedAvatar >= 0
                                      ? AssetImage(
                                              'assets/loginRegister/avatars/${selectedAvatar + 1}.png')
                                          as ImageProvider
                                      : NetworkImage(avatar)),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: 150,
                            height: 33,
                            alignment: Alignment.center,
                            child: Text(
                              name.isEmpty ? "" : nameController.text,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          Container(
                            height: 610,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.08,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 12.0),
                                                    child: Text(
                                                      'Learn Progress ',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  const Gap(7),
                                                  StreamBuilder<
                                                      DocumentSnapshot>(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(userId)
                                                        .collection('profiles')
                                                        .doc(widget.profileId)
                                                        .collection(
                                                            'LessonsFinished')
                                                        .doc(widget.lessonId)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return LinearPercentIndicator(
                                                          percent: 0,
                                                          // animation: true,
                                                          // animationDuration: 900,
                                                          backgroundColor:
                                                              Colors.blueGrey
                                                                  .shade100,
                                                          linearGradient:
                                                              const LinearGradient(
                                                            colors: [
                                                              Color(
                                                                  0xFFFFD700), // Adjust colors
                                                              Color(0xFF00FF00),
                                                            ],
                                                          ),
                                                          lineHeight:
                                                              15, // Smaller height for a sleeker look
                                                          barRadius:
                                                              const Radius
                                                                  .circular(10),
                                                        );
                                                      }

                                                      if (!snapshot.hasData ||
                                                          !snapshot
                                                              .data!.exists) {
                                                        return const Center(
                                                          child: Text(
                                                              'Document does not exist'),
                                                        );
                                                      }

                                                      int age =
                                                          int.parse(widget.age);

                                                      List<int>
                                                          accessibleCategories =
                                                          [];
                                                      List<int>
                                                          subCategoriesMinus =
                                                          []; // FOR MINUS IN THE LENGTH OF CATEGORYLIST[INDEX]
                                                      if (age >= 2 &&
                                                          age <= 3) {
                                                        accessibleCategories = [
                                                          0
                                                        ]; // Letters
                                                        subCategoriesMinus = [
                                                          0,
                                                          0,
                                                          0,
                                                          0
                                                        ]; //
                                                      } else if (age >= 4 &&
                                                          age <= 5) {
                                                        accessibleCategories = [
                                                          0,
                                                          1,
                                                          2
                                                        ]; // Letters, Words, Numbers
                                                        subCategoriesMinus = [
                                                          0,
                                                          1,
                                                          0,
                                                          0
                                                        ]; //
                                                      } else if (age >= 6) {
                                                        accessibleCategories = [
                                                          0,
                                                          1,
                                                          2,
                                                          3
                                                        ]; // All categories
                                                        subCategoriesMinus = [
                                                          0,
                                                          0,
                                                          0,
                                                          0
                                                        ];
                                                      }

                                                      double
                                                          totalProgressValue =
                                                          0.0;
                                                      double
                                                          totalExpectedValue =
                                                          0.0;

                                                      for (int categoryIndex =
                                                              0;
                                                          categoryIndex <
                                                              categoryList
                                                                  .length;
                                                          categoryIndex++) {
                                                        double
                                                            categoryProgressValue =
                                                            0.0;
                                                        double
                                                            categoryExpectedValue =
                                                            0.0;

                                                        for (int progressItem =
                                                                0;
                                                            progressItem <
                                                                categoryList[
                                                                            categoryIndex]
                                                                        .length -
                                                                    subCategoriesMinus[
                                                                        categoryIndex];
                                                            progressItem++) {
                                                          double progress = double
                                                              .parse(snapshot
                                                                      .data![categoryList[
                                                                              categoryIndex]
                                                                          [
                                                                          progressItem]
                                                                      .name] ??
                                                                  '0');
                                                          double total =
                                                              categoryList[categoryIndex]
                                                                          [
                                                                          progressItem]
                                                                      .total ??
                                                                  0;
                                                          categoryProgressValue +=
                                                              progress;
                                                          categoryExpectedValue +=
                                                              total;
                                                        }

                                                        totalProgressValue +=
                                                            categoryProgressValue;
                                                        totalExpectedValue +=
                                                            categoryExpectedValue;
                                                      }

                                                      double totalProgress =
                                                          totalExpectedValue ==
                                                                  0
                                                              ? 0
                                                              : totalProgressValue /
                                                                  totalExpectedValue;

                                                      return LinearPercentIndicator(
                                                        percent: totalProgress,
                                                        // animation: true,
                                                        // animationDuration: 900,
                                                        backgroundColor: Colors
                                                            .grey.shade300,
                                                        linearGradient:
                                                            const LinearGradient(
                                                          colors: [
                                                            Color(0xFFFFD700),
                                                            Color(0xFF00FF00),
                                                          ],
                                                        ),
                                                        lineHeight: 15,
                                                        barRadius: const Radius
                                                            .circular(10),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    "Name",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextField(
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16)),
                                      ),
                                      hintText: 'Name',
                                    ),
                                  ),
                                  const Text(
                                    "Pin",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextField(
                                    controller: pinController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 4,
                                    // readOnly: true,
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16)),
                                      ),
                                      hintText: 'Pin',
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Age",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: List.generate(5, (index) {
                                      int displayNumber = index + 2;
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = index;
                                          });
                                        },
                                        child: CircleAvatar(
                                          backgroundColor:
                                              selectedIndex == index
                                                  ? Colors.blue
                                                  : Colors.white,
                                          child: Text('$displayNumber'),
                                        ),
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Avatar",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
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
                                                  width: 2,
                                                ),
                                              ),
                                              child: CircleAvatar(
                                                radius: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.042,
                                                backgroundImage: AssetImage(
                                                    'assets/loginRegister/avatars/${index + 1}.png'),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: List.generate(
                                          3, // Generate 3 elements
                                          (index) {
                                            if (index == 2) {
                                              // For the 3rd container
                                              return GestureDetector(
                                                onTap: _pickedImageGallery,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: selectedAvatar ==
                                                              index + 3
                                                          ? Colors.blue
                                                          : Colors.blueGrey,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.white,
                                                    radius:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.042,
                                                    child: Icon(
                                                      Icons.photo,
                                                      color: Colors.blueGrey,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              // For the other containers
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedAvatar = index +
                                                        3; // Update selected avatar
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: selectedAvatar ==
                                                              index + 3
                                                          ? Colors.blue
                                                          : Colors.transparent,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: CircleAvatar(
                                                    radius:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.042,
                                                    backgroundImage: AssetImage(
                                                        'assets/loginRegister/avatars/${index + 4}.png'),
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  Container(
                                    width: double.infinity,
                                    child: Material(
                                      borderRadius: BorderRadius.circular(10),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: updateProfile,
                                        child: Container(
                                          width: double.infinity,
                                          height: 45,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF10E119),
                                                Color(0xFF18991E)
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            'Save',
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
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
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => ParentSettings()),
                    );
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
