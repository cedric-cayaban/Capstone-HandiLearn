import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_drawing/screens/insideapp/2.%20short%20stories/selections.dart';

class Story extends StatefulWidget {
  Story({super.key});

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> {
  final PageController _controller = PageController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  int pageNumber = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    forwardPlay();
  }

  void forwardPlay() async {
    pageNumber++;
    setState(() {});
    if (pageNumber < 34) {
      print('Playing audio: $pageNumber');
      await _audioPlayer.play(
        AssetSource('insideApp/shortStories/story1/audio/$pageNumber.mp3'),
      );
    } else {
      return;
    }

    // print(pageNumber);
  }

  void repeatSound() async {
    print('Playing audio: $pageNumber');
    await _audioPlayer.play(
      AssetSource('insideApp/shortStories/story1/audio/$pageNumber.mp3'),
    );
    // print(pageNumber);
  }

  void previousSound() async {
    pageNumber--;
    setState(() {});
    print('Playing audio: $pageNumber');
    await _audioPlayer.play(
      AssetSource('insideApp/shortStories/story1/audio/$pageNumber.mp3'),
    );
    // print(pageNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ...List.generate(33, (index) {
                return SafeArea(
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/insideApp/shortStories/story1/images/${index + 1}.png',
                        fit: BoxFit.fill,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
          pageNumber <= 33
              ? Positioned(
                  bottom: 1,
                  right: 1,
                  child: IconButton(
                    onPressed: () async {
                      if (pageNumber <= 33) {
                        await Future.delayed(const Duration(milliseconds: 300));
                        _controller
                            .nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        )
                            .then((onValue) {
                          forwardPlay();
                        });
                      }
                    },
                    icon: const Icon(Icons.arrow_circle_right_outlined),
                    iconSize: 50,
                    color: Colors.white,
                  ),
                )
              : Positioned(
                  bottom: 15,
                  right: 20,
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.blue),
                        elevation: MaterialStatePropertyAll(2.0)),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ShortStoriesSelection(),
                        ),
                      );
                    },
                    child: const Text(
                      'Home',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
          Positioned(
            bottom: 1,
            left: 1,
            child: IconButton(
              onPressed: () {
                if (pageNumber > 1) {
                  _controller
                      .previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  )
                      .then((onValue) {
                    previousSound();
                  });
                }
              },
              icon: const Icon(Icons.arrow_circle_left_outlined),
              iconSize: 50,
              color: Colors.white,
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.blue),
                elevation: MaterialStatePropertyAll(5.0),
                shadowColor: MaterialStatePropertyAll(Colors.black),
              ),
              onPressed: () {
                repeatSound();
              },
              icon: Icon(Icons.repeat_rounded),
              iconSize: 30,
              color: Colors.white,
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.blue),
                elevation: MaterialStatePropertyAll(5.0),
                shadowColor: MaterialStatePropertyAll(Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ShortStoriesSelection(),
                  ),
                );
              },
              icon: Icon(Icons.home_rounded),
              iconSize: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
