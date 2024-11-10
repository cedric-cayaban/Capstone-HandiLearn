import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:test_drawing/screens/insideapp/5.%20progress/categoryList.dart';
import 'package:test_drawing/screens/insideapp/5.%20progress/progressScreen.dart';
import 'package:test_drawing/screens/useraccount/choose_profile.dart';
import 'package:test_drawing/screens/useraccount/parent_settings.dart';
import 'package:test_drawing/screens/useraccount/set_pin.dart';
import '../../data/userAccount.dart';

class EditProfile extends StatefulWidget {
  EditProfile({
    required this.name,
    required this.age,
    required this.avatar,
    required this.profileId,
    required this.lessonId,
    super.key,
  });

  final String name;
  final String age;
  final String avatar;
  final String profileId;
  final String lessonId;

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
  String name = '';
  String userId = FirebaseAuth.instance.currentUser!.uid;

  void updateProfile() async {
    if (selectedAvatar != -1 &&
        selectedIndex != -1 &&
        nameController.text.isNotEmpty) {
      try {
        // Update the profile document in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId) // Ensure to have the parent user document reference
            .collection('profiles')
            .doc(widget.profileId) // Use the profile ID to locate the document
            .update({
          'name': nameController.text,
          'age': (selectedIndex + 2).toString(),
          'avatar': (selectedAvatar + 1).toString(),
        });

        // Navigate back to the ChooseProfile screen or provide feedback
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => ParentSettings()),
        );
      } catch (error) {
        print('Error updating profile: $error');
      }
    } else {
      print('Provide all inputs');
    }
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name;
    name = widget.name;

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
    double spacer = MediaQuery.of(context).size.height * 0.1;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Edit Profile',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => ParentSettings()),
              );
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
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
                              backgroundImage: selectedAvatar != -1
                                  ? AssetImage(
                                      'assets/loginRegister/avatars/${selectedAvatar + 1}.png')
                                  : const AssetImage(
                                      'assets/loginRegister/avatars/1.png'),
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
                                  MediaQuery.of(context).size.height * 0.04),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.65,
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      color: Colors.white,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                      width: MediaQuery.of(context).size.width,
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
                                                StreamBuilder<DocumentSnapshot>(
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
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return LinearPercentIndicator(
                                                        percent: 0,
                                                        animation: true,
                                                        animationDuration: 900,
                                                        backgroundColor: Colors
                                                            .blueGrey.shade100,
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
                                                        barRadius: const Radius
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
                                                    if (age >= 2 && age <= 3) {
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

                                                    double totalProgressValue =
                                                        0.0;
                                                    double totalExpectedValue =
                                                        0.0;

                                                    for (int categoryIndex = 0;
                                                        categoryIndex <
                                                            categoryList.length;
                                                        categoryIndex++) {
                                                      double
                                                          categoryProgressValue =
                                                          0.0;
                                                      double
                                                          categoryExpectedValue =
                                                          0.0;

                                                      for (int progressItem = 0;
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
                                                        double total = categoryList[
                                                                        categoryIndex]
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
                                                        totalExpectedValue == 0
                                                            ? 0
                                                            : totalProgressValue /
                                                                totalExpectedValue;

                                                    return LinearPercentIndicator(
                                                      percent: totalProgress,
                                                      animation: true,
                                                      animationDuration: 900,
                                                      backgroundColor:
                                                          Colors.grey.shade300,
                                                      linearGradient:
                                                          const LinearGradient(
                                                        colors: [
                                                          Color(0xFFFFD700),
                                                          Color(0xFF00FF00),
                                                        ],
                                                      ),
                                                      lineHeight: 15,
                                                      barRadius:
                                                          const Radius.circular(
                                                              10),
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
                                const Text("Name"),
                                TextField(
                                  controller: nameController,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                    ),
                                    hintText: 'Name',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text("Age"),
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
                                        backgroundColor: selectedIndex == index
                                            ? Colors.blue
                                            : Colors.white,
                                        child: Text('$displayNumber'),
                                      ),
                                    );
                                  }),
                                ),
                                const SizedBox(height: 10),
                                const Text("Avatar"),
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
                                      children: List.generate(3, (index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedAvatar = index + 3;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color:
                                                    selectedAvatar == index + 3
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
                                                  'assets/loginRegister/avatars/${index + 4}.png'),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.05),
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
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
