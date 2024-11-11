import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:test_drawing/screens/insideapp/4.%20games/game_selection.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _colorAnimation = ColorTween(
      begin: Colors.blueAccent,
      end: Colors.greenAccent,
    ).animate(_controller!);
    initializeGame();
  }

  void initializeGame() {
    if (widget.difficulty == "Easy") {
      tileNum = 2;
      options = [
        "B",
        "A",
      ];
      question = '''I am the first letter on the alphabet. Who am I?''';
      correctAnswer = "A";
    } else if (widget.difficulty == "Normal") {
      tileNum = 4;
      options = ["G", "A", "B", "E"];
      question = '''I am the first letter on the alphabet. Who am I?''';
      correctAnswer = "A";
    } else {
      tileNum = 4;
      options = ["APPLE", "ORANGE", "PEAR", "STRAWBERRY"];
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
        text: 'Number of tries is equal to 0',
        confirmBtnText: "Find more games",
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
          Positioned(
            top: MediaQuery.of(context).size.height * .2,
            child: Container(
              height: MediaQuery.of(context).size.height * .1,
              width: MediaQuery.of(context).size.width * .8,
              decoration: BoxDecoration(
                  border: Border.all(
                width: 1,
              )),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  question,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: tileNum != 2
                ? MediaQuery.of(context).size.height * .35
                : MediaQuery.of(context).size.height * .45,
            child: Container(
              height: MediaQuery.of(context).size.height * .42,
              width: MediaQuery.of(context).size.width * .8,
              // decoration: BoxDecoration(color: Colors.red),
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
                                : Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              option,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
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
            bottom: MediaQuery.of(context).size.height * .1,
            child: Text('Number of tries: $tries'),
          ),
        ],
      ),
    );
  }
}
