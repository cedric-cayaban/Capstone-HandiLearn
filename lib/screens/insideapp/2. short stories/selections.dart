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
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "assets/insideApp/shortStories/selectionBg.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.33,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: const BoxDecoration(
                  color: Color(0xFFe8f5fb),
                  border: Border(
                    top: BorderSide(color: Colors.blue),
                  ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: Stack(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 10,
                      child: Text(
                        'Short stories',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      // color: Colors.black,
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: GridView.builder(
                          padding: EdgeInsets.all(12),
                          itemCount: 4,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.85,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 35,
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (context, index) => InkWell(
                            onTap: index == 0
                                ? () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) => Story(),
                                      ),
                                    );
                                  }
                                : null,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  12), // Adjust the radius as needed
                              child: Stack(
                                children: [
                                  Image.asset(
                                    "assets/insideApp/shortStories/story${index + 1}.png",
                                    fit: BoxFit.cover,
                                  ),
                                  // Conditionally add the lock icon if the index is not equal to 1
                                  if (index != 0)
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            'assets/insideApp/padlock.png',
                                            width: double
                                                .infinity, // Adjust the size of the lock icon as needed
                                            height: double.infinity,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
