import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_drawing/data/userAccount.dart';
import 'package:test_drawing/provider/lesson_provider.dart';
import 'package:test_drawing/provider/user_provider.dart';
import 'package:test_drawing/screens/insideapp/home.dart';
import 'package:test_drawing/screens/useraccount/choose_profile.dart';
import 'package:test_drawing/screens/useraccount/create_profile.dart';

class EnterPin extends StatefulWidget {
  const EnterPin({Key? key}) : super(key: key);
  
  @override
  State<EnterPin> createState() => _EnterPinState();
}

class _EnterPinState extends State<EnterPin> {
  String enteredPin = '';
  bool isPinVisible = false;
  String password = '1234';
  String profilePin = "";

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

  // void getData() async {
  //   print(id);
  //   User user = FirebaseAuth.instance.currentUser!;
  //   String _uid = user.uid;
  //   final DocumentSnapshot profileDoc = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(_uid)
  //       .collection('profiles')
  //       .doc(id)
  //       .get();
  //   print(profileDoc.get('pin'));
  //   profilePin = profileDoc.get('pin');
  //   // name = profileDoc.get('name');
  //   // print(name);
  //   setState(() {});
  // }

  void addProfile(String pin) async {
    print(pin);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUserData();

    if (pin == userProvider.pin) {
      await userProvider.fetchUserData();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => Home(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize:
                  MainAxisSize.min, // Ensures the dialog takes minimal space
              children: [
                Image.asset('assets/loginRegister/notverified.png'),
                SizedBox(height: 5), // Space between image and text
                Text(
                  'Pin is incorrect',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                Text('Enter the correct pin for this profile'),
              ],
            ),
            actions: [
              Container(
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () async {
                      enteredPin = "";
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF10E119),
                            Color(0xFF18991E),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Okay',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () async {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChooseProfile(),
                        ),
                      );
                    },
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF10E119),
                            Color(0xFF18991E),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Choose another profile',
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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => ChooseProfile(),
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height * 0.4,
                child: Container(
                  height: 420,
                  width: MediaQuery.of(context).size.width * 0.83,
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
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            'Enter profile pin',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600),
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
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      isPinVisible ? 100.0 : 100),
                                  color: index < enteredPin.length
                                      ? isPinVisible
                                          ? Colors.green
                                          : CupertinoColors.activeBlue
                                      : CupertinoColors.activeBlue
                                          .withOpacity(0.1),
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
                            isPinVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),

                        // SizedBox(height: isPinVisible ? 10.0 : 8.0),

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const TextButton(
                                onPressed: null, child: SizedBox()),
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
            ],
          ),
        ),
      ),
    );
  }
}
