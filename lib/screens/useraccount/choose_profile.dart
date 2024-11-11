import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_drawing/data/userAccount.dart';
import 'package:test_drawing/provider/progress_provider.dart';
import 'package:test_drawing/screens/insideapp/home.dart';
import 'package:test_drawing/screens/useraccount/create_profile.dart';
import 'package:test_drawing/screens/useraccount/enterPin.dart';
import 'package:test_drawing/screens/useraccount/login.dart';
import 'package:test_drawing/screens/useraccount/parent_settings.dart';

class ChooseProfile extends StatefulWidget {
  const ChooseProfile({super.key});

  @override
  State<ChooseProfile> createState() => _ChooseProfileState();
}

class _ChooseProfileState extends State<ChooseProfile> {
  var collection = FirebaseFirestore.instance.collection('users');
  late List<Map<String, dynamic>> items = [];
  bool isLoaded = false;

  _incrementCounter() async {
    List<Map<String, dynamic>> tempList = [];
    User user = FirebaseAuth.instance.currentUser!;
    var data = await collection.get();

    await Future.wait(data.docs.map((element) async {
      if (element.id == user.uid) {
        var subcollection = element.reference.collection('profiles');
        var subcollectionData = await subcollection.get();

        subcollectionData.docs.forEach((subElement) {
          tempList.add(subElement.data());
        });
      }
    }));

    setState(() {
      items = tempList;
      isLoaded = true;
    });

    print(items);
  }

  @override
  void initState() {
    super.initState();
    _incrementCounter();
  }

  @override
  Widget build(BuildContext context) {
    String name = 'tope';
    int selectedIndex = 0; // Variable to store the selected index

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'User selection',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
          icon: const Icon(
            Icons.logout,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ParentSettings()),
              );
            },
            icon: const Icon(
              Icons.person,
              color: Colors.black,
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      // endDrawer: Drawer(
      //   child: Column(
      //     children: [
      //       DrawerHeader(
      //         child: Text('Drawer'),
      //       ),
      //       DrawerButton(
      //         onPressed: () {},
      //         color: Colors.red,
      //       ),
      //       IconButton(
      //           onPressed: () {
      //             FirebaseAuth.instance.signOut();
      //           },
      //           icon: Icon(Icons.logout)),
      //     ],
      //   ),
      // ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/loginRegister/bgPin.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(21.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  // border: Border.all(color: Colors.black),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 2, // Spread radius
                      blurRadius: 7, // Blur radius
                      offset: const Offset(
                          0, 3), // Changes the position of the shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 8.0, left: 8, top: 20, bottom: 8),
                  child: Column(
                    children: [
                      Text(
                        "Who's using the app?",
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        child: isLoaded
                            ? GridView.builder(
                                padding: const EdgeInsets.all(
                                    8.0), // Add padding if needed
                                itemCount: items.length +
                                    1, // Add one extra item for the "Create Profile" button
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      2, // Number of columns in the grid
                                  crossAxisSpacing:
                                      5, // Horizontal space between items
                                  mainAxisSpacing:
                                      5, // Vertical space between items
                                  childAspectRatio:
                                      1 / 1.1, // Aspect ratio of each item
                                ),
                                itemBuilder: (context, index) {
                                  // If the index is the last item, show the "Create Profile" button
                                  if (index == items.length) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 28.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const CreateProfile(),
                                            ),
                                          );
                                        },
                                        child: const Card(
                                          elevation: 5,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 16),
                                          shape: CircleBorder(),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.add_circle_outline,
                                                  size: 60,
                                                  color: Colors.blue,
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  'Add profile',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return GestureDetector(
                                      onTap: () {
                                        selectedIndex = index;
                                        name =
                                            items[index]['name'] ?? 'not given';
                                        print(name);
                                        var profileId =
                                            items[index]['profile id'];
                                        id = profileId;
                                        lessonid = items[index]['lesson id'];
                                        print(profileId);
                                        Provider.of<ProgressProvider>(context,
                                                listen: false)
                                            .setProfileId(profileId);
                                        Provider.of<ProgressProvider>(context,
                                                listen: false)
                                            .setLessonId(lessonid);

                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => const EnterPin(),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Card(
                                            elevation: 5,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 16),
                                            shape: const CircleBorder(),
                                            child: GridTile(
                                              child: items[index]['avatar'] !=
                                                      null
                                                  ? Image.asset(
                                                      'assets/loginRegister/avatars/${items[index]['avatar']}.png',
                                                    )
                                                  : const CircularProgressIndicator(),
                                            ),
                                          ),
                                          Text(
                                            items[index]['name'] ?? 'not given',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
