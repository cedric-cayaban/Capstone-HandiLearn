import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:test_drawing/provider/user_provider.dart';
import 'package:test_drawing/screens/1).%20insideapp/4.%20games/difficulty.dart';


import '../home.dart';

class Games extends StatefulWidget {
  const Games({super.key});

  @override
  State<Games> createState() => _GamesState();
}

class _GamesState extends State<Games> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

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
                  'assets/insideApp/games/game_visual.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.12,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    'Mini Games',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 10,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => Home(),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20, top: 20),
                      child: Text(
                        'Choose your game',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.only(
                            right: 20, left: 20, bottom: 20),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    2, // Number of items in each row
                                crossAxisSpacing: 10, // Spacing between columns
                                childAspectRatio: 1.2 // Spacing between rows
                                ),
                        itemCount: 6, // Total number of images
                        itemBuilder: (context, index) {
                          // Define each image and its tap event
                          switch (index) {
                            case 0:
                              return InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DifficultyScreen(game: 'quiz_game'),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                    'assets/insideApp/games/object_odyssey.png'),
                              );
                            case 1:
                              return InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DifficultyScreen(game: 'pictoword'),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                    'assets/insideApp/games/pictoword.png'),
                              );
                            case 2:
                              return InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DifficultyScreen(game: 'memory_game'),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                    'assets/insideApp/games/mind_match.png'),
                              );
                            case 3:
                              return InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DifficultyScreen(
                                          game: 'sliding_game'),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                    'assets/insideApp/games/sliding_puzzle.png'),
                              );
                            case 4:
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (context) =>
                                        DifficultyScreen(game: 'letter_search'),
                                  ));
                                },
                                child: Image.asset(
                                    'assets/insideApp/games/letter_search.png'),
                              );
                            case 5:
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (context) =>
                                        DifficultyScreen(game: 'word_search'),
                                  ));
                                },
                                child: Image.asset(
                                    'assets/insideApp/games/word_search.png'),
                              );
                            default:
                              return Container();
                          }
                        },
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
