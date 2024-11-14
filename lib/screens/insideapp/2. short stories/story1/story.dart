import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickalert/quickalert.dart';
import 'package:test_drawing/screens/insideapp/2.%20short%20stories/selections.dart';
import 'package:test_drawing/screens/insideapp/home.dart';

class Story extends StatefulWidget {
  Story({super.key});

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> {
  final PageController _controller = PageController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  int pageNumber = 1;
  int imageNumber = 1;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // forwardPlay();
    initPlay();
  }

  void initPlay() async {
    if (pageNumber < 10) {
      print('Playing audio: $pageNumber');

      await _audioPlayer.play(
        AssetSource(
          'insideApp/shortStories/story1/audio/Story P${pageNumber}.mp3',
        ),
      );
    } else {
      print('End of story. No further audio.');
      await _audioPlayer.stop();
    }
  }

  void forwardPlay() async {
    if (pageNumber != 10) {
      pageNumber++;
      setState(() {});
    }
    if (pageNumber < 10) {
      print('Playing audio: $pageNumber');

      await _audioPlayer.play(
        AssetSource(
          'insideApp/shortStories/story1/audio/Story P${pageNumber}.mp3',
        ),
      );
    } else if (pageNumber == 10) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: "End of Story",
        onConfirmBtnTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => ShortStoriesSelection()));
        },
      );
    } else {
      print('End of story. No further audio.');
      await _audioPlayer.stop();
    }
  }

  void repeatSound() async {
    if (pageNumber <= 10) {
      print('Playing audio: $pageNumber');
      await _audioPlayer.play(
        AssetSource(
            'insideApp/shortStories/story1/audio/Story P${pageNumber}.mp3'),
      );
    }
  }

  void previousSound() async {
    pageNumber--;
    setState(() {});
    print('Playing audio: $pageNumber');
    await _audioPlayer.play(
      AssetSource(
          'insideApp/shortStories/story1/audio/Story P${pageNumber}.mp3'),
    );
    // print(pageNumber);
  }

  @override
  void dispose() {
    // Stop the audio
    _audioPlayer.stop();
    _audioPlayer.dispose(); // Dispose of the audio player
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/insideApp/shortStories/story1/images/Short stories${pageNumber}.png',
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
          ),
          // PageView(
          //   controller: _controller,
          //   physics: const NeverScrollableScrollPhysics(),
          //   children: [
          //     ...List.generate(10, (index) {
          //       return SafeArea(
          //         child: Stack(
          //           children: [
          //             Image.asset(
          //               'assets/insideApp/shortStories/story1/images/Short stories${index + 1}.png',
          //               fit: BoxFit.fill,
          //               height: double.infinity,
          //               width: double.infinity,
          //             ),
          //           ],
          //         ),
          //       );
          //     }),
          //   ],
          // ),
          pageNumber <= 10
              ? Positioned(
                  bottom: 20,
                  right: MediaQuery.of(context).size.width * .03,
                  child: InkWell(
                    onTap: () async {
                      if (pageNumber <= 10) {
                        // await Future.delayed(const Duration(milliseconds: 300));
                        // _controller
                        //     .nextPage(
                        //   duration: const Duration(milliseconds: 300),
                        //   curve: Curves.easeInOut,
                        // )
                        //     .then((onValue) {
                        //   forwardPlay();
                        // });
                        forwardPlay();
                      }
                    },
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/insideApp/shortStories/Forward.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                )
              : Positioned(
                  bottom: 25,
                  right: MediaQuery.of(context).size.width * .03,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => ShortStoriesSelection(),
                        ),
                      );
                    },
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/insideApp/shortStories/Home.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
          Positioned(
            bottom: 20,
            right: MediaQuery.of(context).size.width * .35,
            child: InkWell(
              onTap: () async {
                if (pageNumber > 1) {
                  // _controller
                  //     .previousPage(
                  //   duration: const Duration(milliseconds: 300),
                  //   curve: Curves.easeInOut,
                  // )
                  //     .then((onValue) {
                  //   previousSound();
                  // });
                  previousSound();
                }
              },
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/insideApp/shortStories/Backward.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: InkWell(
              onTap: repeatSound,
              child: Container(
                height: 28,
                width: 33,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage('assets/insideApp/shortStories/Repeat.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => ShortStoriesSelection(),
                  ),
                );
              },
              child: Container(
                height: 28,
                width: 33,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/insideApp/shortStories/Home.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
