import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:test_drawing/screens/useraccount/login.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();

  bool password() {
    if (_emailController.text.trim() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future passwordReset() async {
    try {
      if (password()) {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _emailController.text.trim());

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                mainAxisSize:
                    MainAxisSize.min, // Ensures the dialog takes minimal space
                children: [
                  Image.asset('assets/loginRegister/verified.png'),
                  SizedBox(height: 5), // Space between image and text
                  Text(
                    'Reset Password Sent',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  Text(
                      textAlign: TextAlign.center,
                      'Continue to your email and click the link to reset your password'),
                ],
              ),
              actions: [
                Container(
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () async {
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
                          'Continue to login',
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
    } on FirebaseAuthException catch (e) {
      print(e);
      // QuickAlert.show(
      //   context: context,
      //   type: QuickAlertType.error,
      //   title: 'Oops...',
      //   text: 'Enter Credentials',
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/loginRegister/bg2.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reset',
                      style: TextStyle(fontSize: 44),
                    ),
                    const Text(
                      'Password',
                      style: TextStyle(fontSize: 44),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        hintText: 'Email',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double
                          .infinity, // Make the button fill the available width
                      child: Material(
                        borderRadius: BorderRadius.circular(
                            10), // Set your desired border radius here
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                              10), // Ensure the ripple effect respects the border radius
                          onTap: passwordReset,
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
                              'Continue',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
