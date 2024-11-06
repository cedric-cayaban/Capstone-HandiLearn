import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class Question {
  String imagePath;
  List<String> options;
  int correctOption;
  String clue;
  String descp;

  Question({
    required this.imagePath,
    required this.options,
    required this.correctOption,
    required this.clue,
    required this.descp,
  });
}

class Pictoword extends StatefulWidget {
  Pictoword({required this.difficulty, super.key});

  final String difficulty;

  @override
  _PictowordState createState() => _PictowordState();
}

class _PictowordState extends State<Pictoword> {
  int currentLevel = 1;
  int totalScore = 0;
  int currentQuestionIndex = 0;
  TextEditingController answerController = TextEditingController();
  bool isFinished = false;

  List<Question> questions = [
    Question(
      imagePath: 'assets/insideApp/games/2/bookGame.png',
      clue: "4 LETTERS",
      options: ['Book'],
      descp:
          "It's a tool full of stories and facts that help you learn and have fun!",
      correctOption: 0,
    ),
    Question(
      imagePath: 'assets/insideApp/games/2/bagGame.png',
      clue: "3 LETTERS",
      descp:
          "It's a portable storage space for your things when you're not at home!",
      options: ['Bag'],
      correctOption: 0,
    ),
    Question(
      imagePath: 'assets/insideApp/games/2/chairGame.png',
      clue: "5 LETTERS",
      descp: "It's something you sit on that helps you feel comfy and relax!",
      options: ['Chair'],
      correctOption: 0,
    ),
    Question(
      imagePath: 'assets/insideApp/games/2/crayonsGame.png',
      clue: "7 LETTERS",
      descp:
          "They're colorful sticks that help you turn plain paper into amazing, vibrant art!",
      options: ['Crayons'],
      correctOption: 0,
    ),
    Question(
      imagePath: 'assets/insideApp/games/2/eraserGame.png',
      clue: "6 LETTERS",
      descp:
          "It's a special tool that helps you fix mistakes when you're drawing or writing!",
      options: ['Eraser'],
      correctOption: 0,
    ),
    Question(
      imagePath: 'assets/insideApp/games/2/notebookGame.png',
      clue: "8 LETTERS",
      descp:
          "It's a book where you can write and draw your thoughts and ideas!",
      options: ['Notebook'],
      correctOption: 0,
    ),
    Question(
      imagePath: 'assets/insideApp/games/2/pencilGame.png',
      clue: "6 LETTERS",
      descp:
          "It's a tool that lets you write, draw, and create by leaving marks on paper!",
      options: ['Pencil'],
      correctOption: 0,
    ),
    Question(
      imagePath: 'assets/insideApp/games/2/rulerGame.png',
      clue: "6 LETTERS",
      descp:
          "It's a straight tool that helps you draw lines and measure things accurately!",
      options: ['Ruler'],
      correctOption: 0,
    ),
    Question(
      imagePath: 'assets/insideApp/games/2/scissorGame.png',
      clue: "7 LETTERS",
      descp:
          "It's a tool with two sharp parts that helps you cut paper and make cool crafts!",
      options: ['Scissor'],
      correctOption: 0,
    ),
    Question(
      imagePath: 'assets/insideApp/games/2/shoesGame.png',
      clue: "5 LETTERS",
      descp:
          "They're special things you wear on your feet to protect them and walk comfortably!",
      options: ['Shoes'],
      correctOption: 0,
    ),
    // Add more questions for other levels
  ];

  void QuitGame() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Are you sure you want to end the game?',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: Colors.green,
      onConfirmBtnTap: () {
        // Navigator.push(context, MaterialPageRoute(builder: (_) => Games()));
      },
    );
  }

  void checkAnswer() {
    String userAnswer = answerController.text.trim().toLowerCase();
    String correctAnswer = questions[currentQuestionIndex]
        .options[questions[currentQuestionIndex].correctOption]
        .toLowerCase();
    bool isFinished = false;

    if (userAnswer == correctAnswer && totalScore < 100) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Good Job!',
        text: 'Your Answer is Correct.',
      );

      setState(() {
        totalScore += 10;
        currentQuestionIndex++;

        if (currentQuestionIndex >= questions.length) {
          currentQuestionIndex = 0;
        }
        if (totalScore == 100) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'Good Job!',
            text: 'Your Answer is Correct.',
          );
          isFinished = true;
        }
        if (isFinished == true) {
          // Navigator.push(context, MaterialPageRoute(builder: (_) => Games()));
        }
      });
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Wrong Answer. Try Again',
      );
    }
    // totalScore = 100;

    answerController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC3EEFF),
      appBar: AppBar(
        backgroundColor: Color(0xFF0C6699),
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 30,
          ),
        ),
        title: Text(
          'PICTOWORD',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                questions[currentQuestionIndex].imagePath,
                height: 300.0,
                width: 300.0,
              ),
              SizedBox(height: 20.0),
              Center(
                child: Text(
                  'Score: $totalScore',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0C6699),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  minLines: 1,
                  maxLines: null,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  controller: answerController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      color: Color(0xFF0C6699),
                      onPressed: () {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.info,
                          title:
                              'Clue: ${questions[currentQuestionIndex].clue}',
                          text: questions[currentQuestionIndex].descp,
                        );
                      },
                      icon: Icon(
                        Icons.lightbulb_sharp,
                        color: Color(0xFF597E52),
                      ),
                    ),
                    label: Text("Your Answer"),
                    hintText: "Enter Answer Here",
                    hintStyle: TextStyle(color: Color(0xFF0C6699)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF163020))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF163020))),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.all(10),
                  fixedSize: Size(230, 60),
                  textStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  shadowColor: Color(0xFF0C6699),
                  side: BorderSide(
                    color: Colors.black87,
                    width: 2,
                  ),
                  shape: StadiumBorder(),
                ),
                onPressed: () {
                  checkAnswer();
                },
                child: Text(
                  'Submit Answer',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  padding: EdgeInsets.all(10),
                  fixedSize: Size(230, 60),
                  textStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  shadowColor: Color(0xFF7D0A0A),
                  side: BorderSide(
                    color: Colors.black87,
                    width: 2,
                  ),
                  shape: StadiumBorder(),
                ),
                onPressed: () {
                  QuitGame();
                },
                child: Text(
                  'Quit Game',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
