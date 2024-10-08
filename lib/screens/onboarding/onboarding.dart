import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:test_drawing/screens/onboarding/page1.dart';
import 'package:test_drawing/screens/onboarding/page2.dart';
import 'package:test_drawing/screens/onboarding/page3.dart';
import 'package:test_drawing/screens/onboarding/page4.dart';
import 'package:test_drawing/screens/onboarding/page5.dart';
import 'package:test_drawing/screens/onboarding/page6.dart';
import 'package:test_drawing/screens/onboarding/page7.dart';
import 'package:test_drawing/screens/useraccount/login.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController _controller = PageController();

  //for tracking of pageview
  bool onLastPage = false;
  bool onFirstPage = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 6);
                onFirstPage = (index != 0);
              });
            },
            children: const [
              Page1(),
              Page2(),
              Page3(),
              Page4(),
              Page5(),
              Page6(),
              Page7(),
            ],
          ),
          onLastPage
              ? Positioned(
                  bottom: 40,
                  right: 20,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Finish',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.orange),
                    ),
                  ),
                )
              : Positioned(
                  bottom: 40,
                  right: 20,
                  child: IconButton(
                    onPressed: () {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                    icon: Icon(Icons.navigate_next_rounded),
                    color: Colors.white,
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.orange),
                        iconSize: WidgetStatePropertyAll(40)),
                  ),
                ),
          Positioned(
            bottom: 50,
            left: 20,
            child: SmoothPageIndicator(
              controller: _controller,
              count: 7,
              effect: ExpandingDotsEffect(
                // spacing: 8.0,
                // radius: 4.0,
                dotWidth: 10.0,
                dotHeight: 10.0,
                // paintStyle: PaintingStyle.stroke,
                // strokeWidth: 1.5,
                dotColor: Color(0xFFd9d9d9),
                activeDotColor: Color(0xFFFF9800),
              ),
            ),
          ),
          Positioned(
              right: 10,
              top: 30,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LoginScreen(),
                    ),
                  );
                },
                child: Text(
                  'Skip',
                  style: TextStyle(color: Colors.grey),
                ),
              )),
          // Padding(
          //   padding: const EdgeInsets.only(left: 25, right: 25),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       SizedBox(
          //         height: 30,
          //       ),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.end,
          //         children: [
          //           TextButton(
          //             onPressed: () {
          //               Navigator.of(context).push(
          //                 MaterialPageRoute(
          //                   builder: (_) => LoginScreen(),
          //                 ),
          //               );
          //             },
          //             child: const Text(
          //               'Skip',
          //               style: TextStyle(
          //                   color: Colors.black, fontWeight: FontWeight.w900),
          //             ),
          //           )
          //         ],
          //       ),
          //       // const Gap(470),
          //       // SmoothPageIndicator(
          //       //   controller: _controller,
          //       //   count: 5,
          //       //   effect: WormEffect(
          //       //     // spacing: 8.0,
          //       //     // radius: 4.0,
          //       //     dotWidth: 10.0,
          //       //     dotHeight: 10.0,
          //       //     // paintStyle: PaintingStyle.stroke,
          //       //     // strokeWidth: 1.5,
          //       //     dotColor: Color(0xFFd9d9d9),
          //       //     activeDotColor: Color(0xFF018aff),
          //       //   ),
          //       // ),
          //       const Gap(60),
          //       onLastPage
          //           ? ElevatedButton(
          //               style: ElevatedButton.styleFrom(
          //                 backgroundColor: const Color(0xFF018aff),
          //                 fixedSize: const Size(200, 50),
          //                 shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(10),
          //                 ),
          //               ),
          //               onPressed: () {
          //                 Navigator.of(context).push(
          //                   MaterialPageRoute(
          //                     builder: (_) => LoginScreen(),
          //                   ),
          //                 );
          //               },
          //               child: const Text(
          //                 '''Proceed to login''',
          //                 style: TextStyle(
          //                   fontSize: 15,
          //                   color: Colors.white,
          //                   // fontWeight: FontWeight.w900,
          //                 ),
          //               ),
          //               // child: const Text(
          //               //   '''Let's Start!''',
          //               //   style: TextStyle(
          //               //     fontSize: 18,
          //               //     color: Colors.white,
          //               //     // fontWeight: FontWeight.w900,
          //               //   ),
          //               // ),
          //             )
          //           : ElevatedButton(
          //               style: ElevatedButton.styleFrom(
          //                 backgroundColor: const Color(0xFF018aff),
          //                 fixedSize: const Size(200, 50),
          //                 shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(10),
          //                 ),
          //               ),
          //               onPressed: () {
          //                 _controller.nextPage(
          //                   duration: const Duration(milliseconds: 500),
          //                   curve: Curves.easeIn,
          //                 );
          //               },
          //               child: Text(
          //                 onFirstPage ? 'Next' : 'Begin',
          //                 style: const TextStyle(
          //                   fontSize: 15,
          //                   color: Colors.white,
          //                   // fontWeight: FontWeight.w900,
          //                 ),
          //               ),
          //             ),
          //       Gap(90),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
