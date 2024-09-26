import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:test_drawing/data/userAccount.dart';
import 'package:test_drawing/screens/useraccount/login.dart';
import 'package:test_drawing/screens/useraccount/verify_email.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  bool passwordConfirmed() {
    if (_confirmPasswordController.text.trim() ==
        _passwordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  Future createAccount() async {
    if (passwordConfirmed()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());

        await FirebaseAuth.instance.currentUser?.sendEmailVerification();

        // final User? user = FirebaseAuth.instance.currentUser;
        // final _uid = user?.uid;
        // user!.reload();
        // await FirebaseFirestore.instance.collection('users').doc(_uid).set({
        //   'id': _uid,
        //   'first name': _firstNameController.text.trim(),
        //   'last name': _lastNameController.text.trim(),
        //   'email': _emailController.text.trim(),
        // });

        final User? user = FirebaseAuth.instance.currentUser;
        final _uid = user?.uid;
        user!.reload();
        UserData userInfo = UserData(
            id: _uid!,
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            email: _emailController.text.trim());

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyEmail(
              userData: userInfo,
            ),
          ),
        );
      } catch (error) {
        print(error);
      }
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
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/loginRegister/bg2.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(
            children: [
              // Content
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60, left: 30, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        'Account',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      TextField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                          hintText: 'First Name',
                        ),
                      ),
                      Gap(12),
                      TextField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                          hintText: 'Last Name',
                        ),
                      ),
                      Gap(12),
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
                      const Gap(12),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                          hintText: 'Password',
                        ),
                      ),
                      const Gap(12),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                          hintText: 'Confirm Password',
                        ),
                      ),
                      const Gap(12),
                      Container(
                        width: double
                            .infinity, // Make the button fill the available width
                        child: Material(
                          borderRadius: BorderRadius.circular(
                              10), // Set your desired border radius here
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                                10), // Ensure the ripple effect respects the border radius
                            onTap: createAccount,
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
                                'Create account',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => LoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF41A345),
                              ),
                            ),
                          )
                        ],
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
  }
}
