import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
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
    double spacer = MediaQuery.of(context).size.height * 0.1;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset:
            false, // Prevents automatic resizing when keyboard appears
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
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
            icon: const Icon(Icons.arrow_back_ios),
          ),
          
        ),
        body: Stack(
          children: [
            // Background Image
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

            // Scrollable Foreground Content
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(), // Avoids extra bounce
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
                                  MediaQuery.of(context).size.height * 0.08),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.6,
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
                                const Text("What is your child's name"),
                                TextField(
                                  controller: nameController,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(16),
                                      ),
                                    ),
                                    hintText: 'Name',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text("What is your child's age"),
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
                                const Text("Select an avatar"),
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
                                      onTap: saveProfile,
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
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          'Save',
                                          style: GoogleFonts.poppins(
                                              fontSize: 17,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
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
