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
    double spacer = MediaQuery.of(context).size.height * 0.26;
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
          decoration: const BoxDecoration(
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
                Gap(spacer),
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

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: GridView.builder(
                            itemCount: 4,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 0.85,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 35,
                                    crossAxisCount: 2),
                            itemBuilder: (context, index) => ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  7), // Adjust the radius as needed
                              child: Image.asset(
                                "assets/insideApp/shortStories/story${index + 1}.png",
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [
                      //     GestureDetector(
                      //       onTap: () {
                      //         Navigator.of(context).pushReplacement(
                      //           MaterialPageRoute(
                      //             builder: (_) => Story(),
                      //           ),
                      //         );
                      //       },
                      //       child: Image.asset(
                      //         "assets/insideApp/shortStories/story1.png",
                      //         height: 200,
                      //         width: 150,
                      //       ),
                      //     ),
                      //     Image.asset(
                      //       "assets/insideApp/shortStories/story2.png",
                      //       height: 200,
                      //       width: 150,
                      //     ),
                      //   ],
                      // ),
                      // Gap(25),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [
                      //     Image.asset(
                      //       "assets/insideApp/shortStories/story3.png",
                      //       height: 200,
                      //       width: 150,
                      //     ),
                      //     Image.asset(
                      //       "assets/insideApp/shortStories/story4.png",
                      //       height: 200,
                      //       width: 150,
                      //     ),
                      //   ],
                      // ),
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
