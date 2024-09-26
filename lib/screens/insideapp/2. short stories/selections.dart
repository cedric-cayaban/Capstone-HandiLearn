import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:test_drawing/screens/insideapp/2.%20short%20stories/story1/story.dart';
import 'package:test_drawing/screens/insideapp/home.dart';

class ShortStoriesSelection extends StatefulWidget {
  ShortStoriesSelection({super.key});

  @override
  State<ShortStoriesSelection> createState() => _ShortStoriesSelectionState();
}

class _ShortStoriesSelectionState extends State<ShortStoriesSelection> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
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
                  builder: (_) => Home(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          height: MediaQuery.of(context).size.height, // Use full screen height
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage("assets/insideApp/shortStories/selectionBg.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Gap(220),
                Container(
                  // decoration: BoxDecoration(color: Colors.red),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Short Stories',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => Story(),
                                ),
                              );
                            },
                            child: Image.asset(
                              "assets/insideApp/shortStories/story1.png",
                              height: 200,
                              width: 150,
                            ),
                          ),
                          Image.asset(
                            "assets/insideApp/shortStories/story2.png",
                            height: 200,
                            width: 150,
                          ),
                        ],
                      ),
                      Gap(25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            "assets/insideApp/shortStories/story3.png",
                            height: 200,
                            width: 150,
                          ),
                          Image.asset(
                            "assets/insideApp/shortStories/story4.png",
                            height: 200,
                            width: 150,
                          ),
                        ],
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
  }
}
