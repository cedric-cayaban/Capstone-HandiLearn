import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:test_drawing/screens/2.)%20onboarding/page1.dart';
import 'package:test_drawing/screens/2.)%20onboarding/page2.dart';
import 'package:test_drawing/screens/2.)%20onboarding/page3.dart';
import 'package:test_drawing/screens/2.)%20onboarding/page4.dart';
import 'package:test_drawing/screens/2.)%20onboarding/page5.dart';
import 'package:test_drawing/screens/2.)%20onboarding/page6.dart';
import 'package:test_drawing/screens/2.)%20onboarding/page7.dart';
import 'package:test_drawing/screens/3).%20useraccount/login.dart';

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
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFe4eeff),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: Image.asset(
                'assets/onboarding/moving car.gif',
                height: 340,
                width: MediaQuery.sizeOf(context).width,
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: 0,
              child: Image.asset(
                'assets/onboarding/bg.png',
                height: MediaQuery.of(context).size.height * .80,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: 0,
              child: Image.asset(
                'assets/onboarding/clouds.gif',
                height: 340,
                width: MediaQuery.sizeOf(context).width,
                fit: BoxFit.fill,
              ),
            ),
            // Positioned(
            //   top: 70,
            //   right: 70,
            //   child: Image.asset(
            //     'assets/onboarding/logo.png',
            //     height: 195,
            //     width: 230,
            //     fit: BoxFit.fill,
            //   ),
            // ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.25,
              left: MediaQuery.of(context).size.width * 0.30,
              child: Image.asset(
                'assets/onboarding/dancing abc.gif',
                height: 60,
                width: MediaQuery.of(context).size.width * 0.30,
                fit: BoxFit.fill,
              ),
            ),
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
                    bottom: 20,
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
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.orange),
                      ),
                    ),
                  )
                : Positioned(
                    bottom: 20,
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
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.orange),
                          iconSize: MaterialStatePropertyAll(40)),
                    ),
                  ),
            Positioned(
              bottom: 35,
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
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
