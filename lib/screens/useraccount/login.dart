import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:test_drawing/screens/useraccount/choose_profile.dart';
import 'package:test_drawing/screens/useraccount/forgot_password.dart';
import 'package:test_drawing/screens/useraccount/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false; // For show password feature

  void signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
    } catch (e) {
      print(e);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChooseProfile(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            // Fixed Background Image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/loginRegister/bg1.png"),
                  fit: BoxFit
                      .cover, // Keep the image covering the entire background
                ),
              ),
            ),

            // Foreground Content
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 110, left: 15, right: 15),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 200,
                      width: 230,
                      fit: BoxFit.cover,
                    ),
                    const Gap(10),
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
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ForgotPassword(),
                              ),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: signIn,
                          child: Container(
                            width: double.infinity,
                            height: 45,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF10E119), Color(0xFF18991E)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Login',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account?',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => RegisterScreen()));
                            },
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF41A345),
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
          ],
        ),
      ),
    );
  }
}
