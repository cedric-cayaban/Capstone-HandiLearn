import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_drawing/screens/3).%20useraccount/choose_profile.dart';
import 'package:test_drawing/screens/3).%20useraccount/set_pin.dart';

import '../../data/userAccount.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool? isChecked = false;
  int selectedIndex = -1; // For age
  int selectedAvatar = -1; // For avatar
  final TextEditingController nameController = TextEditingController();
  String url = "";
  File? image;

  void saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      if ((selectedAvatar == -1 && image == null) || selectedIndex == -1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select both age and avatar."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final User? user = _auth.currentUser;
      final _uid = user?.uid;

      if (image != null) {
        final imageTemporary = File(image!.path);

        String imageName = nameController.text + _uid!;

        final ref = FirebaseStorage.instance
            .ref()
            .child('profileImage')
            .child('$imageName.jpg');
        await ref.putFile(imageTemporary);

        url = await ref.getDownloadURL();
      }

      try {
        ProfileData profileData;
        if (selectedAvatar == -1) {
          profileData = ProfileData(
            id: 'top',
            parentId: _uid!,
            name: nameController.text,
            age: (selectedIndex + 2).toString(),
            avatar: "",
            pin: '',
            avatarImage: url,
          );
        } else {
          profileData = ProfileData(
            id: 'top',
            parentId: _uid!,
            name: nameController.text,
            age: (selectedIndex + 2).toString(),
            avatar: (selectedAvatar + 1).toString(),
            pin: '',
            avatarImage: '',
          );
        }

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => SetPin(profileData: profileData),
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error saving profile: $error"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // File? _imageFile;

  // int random() {
  //   Random random = new Random();
  //   int randomNumber = random.nextInt(10000);

  //   return randomNumber;
  // }

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
  void dispose() {
    nameController.dispose();
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
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: spacer, left: 21, right: 21),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Avatar Display
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
                                        : const AssetImage(
                                            'assets/loginRegister/AVATAR.png')),
                              ),
                            ),
                            const SizedBox(height: 5),
                            // Name Display
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: 150,
                              height: 33,
                              alignment: Alignment.center,
                              child: Text(
                                nameController.text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.08,
                            ),
                            // Profile Form Container
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
                                  TextFormField(
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Name is required';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                  ),
                                  const SizedBox(height: 10),

                                  // Age Selection
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

                                  // Avatar Selection
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
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                  ),
                                  // Save Button
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
                                          child: const Text(
                                            "Save Profile",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
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
