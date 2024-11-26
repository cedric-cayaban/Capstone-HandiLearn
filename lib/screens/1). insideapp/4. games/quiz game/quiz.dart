import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:test_drawing/screens/1).%20insideapp/4.%20games/game_selection.dart';
import 'package:test_drawing/screens/1).%20insideapp/4.%20games/instructions/word_search.dart';

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
  AnimationController? _animationController;
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
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _colorAnimation = ColorTween(
      begin: Colors.blueAccent,
      end: Colors.redAccent,
    ).animate(_animationController!);
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
    _animationController?.dispose();
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
      _animationController?.forward().then((_) {
        _animationController?.reverse().then((_) {
          checkAnswer(option);
        });
      });
    }
  }

  var gameInstruction = [
    {
      'title': 'Read the Question',
      'text':
          'At the top of the screen, you’ll see a question. Read it carefully to find out what letter it’s asking about.',
    },
    {
      'title': 'Choose the Answer',
      'text':
          "Below the question, you’ll see two colored boxes with letters. Tap on the box with the letter you think is the correct answer",
    },
    {
      'title': 'Tries Left',
      'text':
          "You have a few tries to get the right answer! Look at the bottom of the screen to see how many tries you have left.",
    },
    {
      'title': 'Have Fun!',
      'text':
          "Keep playing to guess more words and have fun learning new things!",
    },
  ];
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < gameInstruction.length) {
      _controller.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _controller.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void loadInstructions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
          ),
          child: AlertDialog(
            backgroundColor: Colors.white,
            contentPadding: EdgeInsets.all(16),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setDialogState) {
                return SingleChildScrollView(
                  child: SizedBox(
                    height: 350,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView(
                            controller: _controller,
                            onPageChanged: (index) {
                              setDialogState(() {
                                _currentPage = index;
                              });
                            },
                            children: [
                              ...List.generate(gameInstruction.length, (index) {
                                return Column(
                                  // Align content to the start
                                  children: [
                                    Text(
                                      gameInstruction[index]['title']!,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 23,
                                      ),
                                    ),
                                    Gap(20),
                                    Image.asset(
                                      'assets/insideApp/games/quiz/quiz${index + 1}.png',
                                      width:
                                          200, // Adjust image size to fit better
                                      height: 100,
                                      fit: BoxFit.fill,
                                    ),
                                    Gap(20),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        gameInstruction[index]['text']!,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              // WordSearchTip1(),
                              // WordSearchTip2(),
                              // WordSearchTip3(),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed:
                                  _currentPage > 0 ? _previousPage : null,
                              icon: Icon(Icons.arrow_back),
                              color:
                                  _currentPage > 0 ? Colors.blue : Colors.grey,
                            ),
                            Text(' ${_currentPage + 1}'),
                            IconButton(
                              onPressed: _currentPage < gameInstruction.length
                                  ? _nextPage
                                  : null,
                              icon: Icon(Icons.arrow_forward),
                              color: _currentPage < gameInstruction.length - 1
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    ).then((_) {
      // Reset the current page to 0 when the dialog is closed
      setState(() {
        _currentPage = 0;
      });
    });
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
          icon: Image.asset(
              height: MediaQuery.of(context).size.height * 0.045,
              "assets/insideApp/close.png"),
        ),
        actions: [
          IconButton(
            onPressed: () {
              loadInstructions();
            },
            icon: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(
                    height: MediaQuery.of(context).size.height * 0.05,
                    "assets/insideApp/games/instruction.png"),
              ),
            ),
          ),
        ],
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
            top: MediaQuery.of(context).size.height * .37,
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
