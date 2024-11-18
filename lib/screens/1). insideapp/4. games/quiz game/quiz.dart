import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:test_drawing/screens/1).%20insideapp/4.%20games/game_selection.dart';

class Quiz extends StatefulWidget {
  Quiz({required this.difficulty, super.key});

  final String difficulty;
  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> with SingleTickerProviderStateMixin {
  late String question;
  late List<String> options = [];
  late String correctAnswer;
  String? selectedOption;
  AnimationController? _controller;
  Animation<Color?>? _colorAnimation;
  int tries = 2;
  late int tileNum;

  // List of colors for options
  List<Color> optionColors = [
    Color(0xFF6fb589),
    Color(0xFFf6ac84),
    Color(0xFF7fbed0),
    Color(0xFFf5e86e),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _colorAnimation = ColorTween(
      begin: Colors.blueAccent,
      end: Colors.redAccent,
    ).animate(_controller!);
    initializeGame();
  }

  void initializeGame() {
    if (widget.difficulty == "Easy") {
      tileNum = 2;
      options = ["B", "A"];
      question = '''I am the first letter on the alphabet. Who am I?''';
      correctAnswer = "A";
    } else if (widget.difficulty == "Normal") {
      tileNum = 4;
      options = ["G", "A", "B", "E"];
      question = '''I am the first letter on the alphabet. Who am I?''';
      correctAnswer = "A";
    } else {
      tileNum = 4;
      options = ["APPLE", "ORANGE", "PEAR", "BERRY"];
      question =
          '''I'm a sweet, crunchy fruit. You find me in pies and juice. Who Am I?''';
      correctAnswer = "APPLE";
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void checkAnswer(String option) {
    bool isCorrect = option == correctAnswer;
    tries--;

    QuickAlert.show(
      context: context,
      type: isCorrect ? QuickAlertType.success : QuickAlertType.warning,
      title: isCorrect ? "Good job!" : "Try Again!",
      text: isCorrect ? 'Find more games' : "Pick another answer",
      confirmBtnColor: isCorrect ? Colors.greenAccent.shade700 : Colors.orange,
      onConfirmBtnTap: !isCorrect
          ? () {
              setState(() => selectedOption = null);
              Navigator.of(context).pop();
            }
          : () {
              setState(() => selectedOption = null);
              Navigator.of(context).pop();
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (_) => Games()));
            },
    );
  }

  void animateButton(String option) {
    if (tries == 0) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "Oops!",
        text: "You've used all your tries. Let's try another game!",
        confirmBtnText: "Find more fun games",
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => Games()));
        },
      );
    } else {
      setState(() => selectedOption = option);
      _controller?.forward().then((_) {
        _controller?.reverse().then((_) {
          checkAnswer(option);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) => Games()));
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.black,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/insideApp/games/quiz-bg.jpg',
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * .2,
            child: Container(
              height: MediaQuery.of(context).size.height * .15,
              width: MediaQuery.of(context).size.width * .8,
              decoration: BoxDecoration(
                color: Color(0xFF6B8E23).withOpacity(0.2), // Soft pastel color
                border: Border.all(
                  color: Color(0xFF6B8E23), // Fun border color
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(25), // More rounded corners
                boxShadow: [
                  BoxShadow(
                    color:
                        Color(0xFF6B8E23).withOpacity(0.2), // Soft pink shadow
                    spreadRadius: 4,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 8.0),
                    //   child: Icon(
                    //     Icons.lightbulb_outline, // Friendly icon
                    //     color: Colors.yellowAccent,
                    //     size: 30,
                    //   ),
                    // ),
                    Expanded(
                      child: Center(
                        child: Text(
                          question,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: tileNum == 2 ? 24 : 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3E2723), // Child-friendly color
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * .45,
            child: Container(
              height: MediaQuery.of(context).size.height * .42,
              width: MediaQuery.of(context).size.width * .8,
              // color: Colors.red,
              child: GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  String option = options[index];
                  bool isSelected = option == selectedOption;

                  return GestureDetector(
                    onTap: () => animateButton(option),
                    child: AnimatedBuilder(
                      animation: _colorAnimation!,
                      builder: (context, child) {
                        return Container(
                          decoration: BoxDecoration(
                              color: isSelected
                                  ? _colorAnimation?.value
                                  : optionColors[index % optionColors.length],
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 4),
                                ),
                              ]),
                          child: Center(
                            child: Text(
                              option,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * .08,
            left: 30,
            child: Text(
              'Tries left: $tries',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Color(0xFF3E2723),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
