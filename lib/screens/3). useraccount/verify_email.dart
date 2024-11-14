import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:test_drawing/data/userAccount.dart';
import 'package:test_drawing/screens/3).%20useraccount/login.dart';
import 'package:test_drawing/screens/3).%20useraccount/register.dart';

class VerifyEmail extends StatefulWidget {
  final UserData userData;

  const VerifyEmail({Key? key, required this.userData}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  void initState() {
    super.initState();
    var data = widget.userData;
    print(data.id);
    print(data.firstName);
    print(data.lastName);
    print(data.email);
  }

  void checkEmail() async {
    await FirebaseAuth.instance.currentUser!.reload();
    var updatedUser = FirebaseAuth.instance.currentUser;

    if (updatedUser!.emailVerified) {
      // Show a dialog for successful verification
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
                  'Account Created',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text('Continue to login'),
              ],
            ),
            actions: [
              Container(
                width: double.infinity,
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      var _uid = FirebaseAuth.instance.currentUser!.uid;
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(_uid)
                          .set({
                        'id': _uid,
                        'first name': widget.userData.firstName,
                        'last name': widget.userData.lastName,
                        'email': widget.userData.email,
                      });
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
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
                        'Continue',
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
      print('verified');
    } else {
      // Show a dialog for unsuccessful verification
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
                  'Email Not Verified',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                Text('Verify your email'),
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
                      FirebaseAuth.instance.currentUser!.delete();
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => LoginScreen(),
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
                        'Go back to login',
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
      print('not verified');
    }
  }

  void resendEmail() async {
    await FirebaseAuth.instance.currentUser!.reload();
    await FirebaseAuth.instance.currentUser?.sendEmailVerification();
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
                MaterialPageRoute(builder: (_) => RegisterScreen()),
              );
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/loginRegister/bg3.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 33), // Fixed padding
                  child: Text(
                    'Verify your email address',
                    style: TextStyle(fontSize: 34),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  'We have just sent an email verification link to your email. Please check your email and click the link to verify your address.',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                Gap(19),
                Text(
                  'Click the Continue button after verifying',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                Gap(37),
                Container(
                  width: double.infinity,
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: checkEmail,
                      child: Container(
                        width: double.infinity,
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
                          'Continue',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 0), // No extra space between buttons
                TextButton(
                  onPressed: resendEmail,
                  child: Text('Resend email link'),
                ),
                SizedBox(height: 0), // No extra space between buttons
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
                  },
                  child: Text('Back to login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
