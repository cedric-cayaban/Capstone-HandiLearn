import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_drawing/screens/1).%20insideapp/3.%20scanning/camera_screen.dart';
import 'package:test_drawing/screens/1).%20insideapp/home.dart';

class Instruction extends StatefulWidget {
  const Instruction({super.key});

  @override
  _InstructionState createState() => _InstructionState();
}

class _InstructionState extends State<Instruction> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _instructions = [
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Look at the Picture!',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Image.asset('assets/insideApp/scanning/insImage1.png'),
        //const Gap(10),
        Text(
          '1.1 The game will show you a picture of something fun! It could be a toy, or a book.',
          style:
              GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.normal),
        ),
        Text(
          '1.2 Remember what it looks like. Can you see it in your mind?',
          style:
              GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.normal),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Search Around!',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Image.asset('assets/insideApp/scanning/insImage2.png'),
        Text(
          '2.1 Now it’s time to find that thing! Look around your room.',
          style:
              GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.normal),
        ),
        Text(
          '2.2 You can ask a grown-up to help you look, too! It’s like a treasure hunt!',
          style:
              GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.normal),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Time to Scan!',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Image.asset('assets/insideApp/scanning/insImage3.png'),
        Text(
          '3.1 When you find the object, it’s time to use the Scan Button on the game.',
          style:
              GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.normal),
        ),
        Text(
          '3.2 Hold your tablet or phone up to the object and press the button.',
          style:
              GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.normal),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Learn Something New!',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Image.asset('assets/insideApp/scanning/insImage4.png'),
        Text(
          '4.1 Hooray! After you scan, the game will tell you what the object is.',
          style:
              GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.normal),
        ),
        Text(
          '4.2 You’ll hear a voice that tells you what it does and what it’s called. It’s like magic!',
          style:
              GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.normal),
        ),
      ],
    ),
    // Column(
    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //   children: [
    //     Text(
    //       'Get Your Rewards!',
    //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    //     ),
    //     Text(
    //         '5.1 Each time you find and scan something, you earn points or fun avatar!'),
    //     Text(
    //         '5.2 Try to find as many objects as you can to collect lots of rewards. How many can you find?'),
    //   ],
    // ),
  ];

  void _nextPage() {
    if (_currentPage < _instructions.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //           builder: (_) => Home(),
      //         ),
      //       );
      //     },
      //     icon: const Icon(
      //       Icons.arrow_back_ios_new_rounded,
      //       size: 30,
      //       color: Colors.black,
      //     ),
      //     //replace with our own icon data.
      //   ),
      // ),
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            child: Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/insideApp/scanning/BG picture.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Positioned(
            left: 10,
            top: 25,
            child: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Home(),
                  ),
                );
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width * .65,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        'Object Scanning Instruction',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.normal),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.32,
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Container(
                height: 420,
                width: MediaQuery.of(context).size.width * .80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF68C2E7), Color(0xFFB3E6D6)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemCount: _instructions.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: _instructions[index],
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _currentPage != 3
                              ? IconButton(
                                  onPressed: _previousPage,
                                  icon: Image.asset(
                                      height: 35,
                                      'assets/insideApp/scanning/back.png'),
                                )
                              : SizedBox(),
                          _currentPage != 3
                              ? Text(
                                  ' ${_currentPage + 1}',
                                  style: TextStyle(fontSize: 13),
                                )
                              : TextButton(
                                  style: ButtonStyle(
                                      elevation: WidgetStatePropertyAll(1),
                                      backgroundColor:
                                          WidgetStatePropertyAll(Colors.orange),
                                      shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)))),
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) => CameraScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Let's Start",
                                    style: TextStyle(color: Colors.white),
                                  )),
                          _currentPage != 3
                              ? IconButton(
                                  onPressed: _nextPage,
                                  icon: Image.asset(
                                      height: 35,
                                      'assets/insideApp/scanning/next.png'),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 40,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Color(0xFF2E91ED)),
                  elevation: WidgetStatePropertyAll(1),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)))),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => CameraScreen(),
                  ),
                );
              },
              child: Text(
                'Skip instruction',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 5,
            child: Image.asset(
              'assets/insideApp/scanning/mascot.png',
              height: 130,
              width: 200,
            ),
          ),
        ],
      ),
    );
  }
}
