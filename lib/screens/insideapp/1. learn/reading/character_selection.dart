import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_drawing/data/userAccount.dart';
import 'package:test_drawing/objects/lesson.dart';
import 'package:test_drawing/screens/insideapp/1.%20learn/reading/selectedItem.dart';

class ReadingCharacterSelection extends StatefulWidget {
  ReadingCharacterSelection({
    super.key,
    required this.lesson,
    required this.activity,
    required this.lessonNumber,
    required this.lessonTitle,
    required this.characterDone,
  });

  final List<Lesson> lesson;
  final String activity;
  final int lessonNumber;
  final String lessonTitle;
  final String characterDone;

  @override
  State<ReadingCharacterSelection> createState() =>
      _ReadingCharacterSelection();
}

class _ReadingCharacterSelection extends State<ReadingCharacterSelection> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int characterDone = int.parse(widget.characterDone);

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.37,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/insideApp/learnWriting/components/selection-visual${widget.lessonNumber + 1}.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 10,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: widget.lessonNumber == 3 || widget.lessonNumber == 6
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.33,
              left: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                height: MediaQuery.of(context).size.height * 0.7,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 70,
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: widget.lesson.length,
                          padding: const EdgeInsets.all(16),
                          itemBuilder: (context, index) {
                            bool isUnlocked = index <= characterDone;
                            return Stack(
                              children: [
                                InkWell(
                                  onTap: isUnlocked
                                      ? () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => SelectedItem(
                                              imgPath:
                                                  widget.lesson[index].imgPath,
                                              character: widget
                                                  .lesson[index].character,
                                              characterIndex: index,
                                              characterDone: characterDone,
                                              lessonField:
                                                  "${widget.lessonTitle}_${widget.activity}",
                                            ),
                                          ));
                                        }
                                      : null,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Image.asset(
                                        widget.lesson[index].imgPath,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                if (!isUnlocked)
                                  Positioned.fill(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 20, right: 20),
                                      child: Container(
                                        color: Colors.black.withOpacity(0.5),
                                        child: const Icon(
                                          Icons.lock,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                      Container(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.275,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/insideApp/learnWriting/components/selection-img.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
