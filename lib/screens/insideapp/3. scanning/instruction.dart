import 'package:flutter/material.dart';
import 'package:test_drawing/screens/insideapp/3.%20scanning/randomize.dart';

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
        Text('Look at the Picture!'),
        Text(
            '1.1 The game will show you a picture of something fun! It could be a toy, a book, '
            'or something outside like a tree.'),
        Text('1.2 Remember what it looks like. Can you see it in your mind?'),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('Search Around!'),
        Text(
            '2.1 Now it’s time to find that thing! Look around your room, in your house, or even outside.'),
        Text(
            '2.2 You can ask a grown-up to help you look, too! It’s like a treasure hunt!'),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('Time to Scan!'),
        Text(
            '3.1 When you find the object, it’s time to use the Scan Button on the game.'),
        Text(
            '3.2 Hold your tablet or phone up to the object and press the button. The scanner will help you check if it’s the right one!'),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('Learn Something New!'),
        Text(
            '4.1 Hooray! After you scan, the game will tell you what the object is.'),
        Text(
            '4.2 You’ll hear a voice that tells you what it does and what it’s called. It’s like magic!'),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('Get Your Rewards!'),
        Text(
            '5.1 Each time you find and scan something, you earn points or fun avatar!'),
        Text(
            '5.2 Try to find as many objects as you can to collect lots of rewards. How many can you find?'),
      ],
    ),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('INSTRUCTION'),
          Text(
              textAlign: TextAlign.center,
              'Hey there, little explorer! Are you ready for a super fun game? '
              'Let’s go on a treasure hunt to find and learn about special things around you! '
              'Here’s how to play:'),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _currentPage != 4
                          ? IconButton(
                              onPressed: _previousPage,
                              icon: Icon(Icons.arrow_back),
                            )
                          : SizedBox(),
                      _currentPage != 4
                          ? Text(' ${_currentPage + 1}')
                          : TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => Randomize(),
                                  ),
                                );
                              },
                              child: Text("Let's Find")),
                      _currentPage != 4
                          ? IconButton(
                              onPressed: _nextPage,
                              icon: Icon(Icons.arrow_forward),
                            )
                          : SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => Randomize(),
                  ),
                );
              },
              child: Text('Skip instruction'))
        ],
      ),
    );
  }
}
