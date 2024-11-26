import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:test_drawing/data/userAccount.dart';
import 'package:test_drawing/provider/progress_provider.dart';
import 'package:test_drawing/provider/user_provider.dart';
import 'package:test_drawing/screens/1).%20insideapp/5.%20progress/categoryList.dart';
import 'package:test_drawing/screens/1).%20insideapp/home.dart';
import 'package:test_drawing/screens/3).%20useraccount/choose_profile.dart';
import 'package:test_drawing/screens/3).%20useraccount/create_profile.dart';
import 'package:test_drawing/screens/3).%20useraccount/edit_profile.dart';
import 'package:test_drawing/screens/3).%20useraccount/enterPin.dart';
import 'package:test_drawing/screens/3).%20useraccount/login.dart';

class ParentSettings extends StatefulWidget {
  const ParentSettings({super.key});

  @override
  State<ParentSettings> createState() => _ParentSettingsState();
}

class _ParentSettingsState extends State<ParentSettings> {
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

  Future<void> deleteProfile(String profileId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('profiles')
          .doc(profileId)
          .delete();
      // After deleting, refresh the profile list
      _incrementCounter();
    } catch (e) {
      print('Error deleting profile: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _incrementCounter();
  }

  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    String name = 'tope';
    int selectedIndex = 0; // Variable to store the selected index
    //int age = Provider.of<UserProvider>(context, listen: false).age;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profiles',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ChooseProfile()),
            );
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
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
                        "Your children profiles",
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        child: isLoaded
                            ? ListView.builder(
                                padding: const EdgeInsets.all(
                                    8.0), // Add padding if needed
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  return Dismissible(
                                    key: Key(items[index]['profile id']),
                                    direction: DismissDirection.endToStart,
                                    confirmDismiss: (direction) async {
                                      // Show confirmation dialog
                                      return await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Delete Profile'),
                                          content: const Text(
                                            'Are you sure you want to delete this profile?',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false); // Cancel
                                              },
                                              child: const Text('No'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(true); // Confirm
                                              },
                                              child: const Text('Yes'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    onDismissed: (direction) async {
                                      // If user confirmed, delete the profile
                                      await deleteProfile(
                                          items[index]['profile id']);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            '${items[index]['name']} profile deleted'),
                                      ));
                                    },
                                    // background: Container(
                                    //   color: Colors.red,
                                    //   alignment: Alignment.centerRight,
                                    //   padding: const EdgeInsets.symmetric(
                                    //       horizontal: 20),
                                    //   child: const Icon(
                                    //     Icons.delete,
                                    //     color: Colors.white,
                                    //   ),
                                    // ),
                                    child: GestureDetector(
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

                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (_) => EditProfile(
                                              name: items[index]['name'],
                                              age: items[index]['age'],
                                              avatar: items[index]['avatar'],
                                              avatarImage: items[index]
                                                  ['avatarImage'],
                                              pin: items[index]['pin'],
                                              profileId: items[index]
                                                  ['profile id'],
                                              lessonId: items[index]
                                                  ['lesson id'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Card(
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.12,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            child: Stack(
                                              alignment: Alignment.centerLeft,
                                              children: [
                                                Positioned(
                                                  left: 20,
                                                  child: CircleAvatar(
                                                    radius:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.035,
                                                    backgroundImage: items[
                                                                    index]
                                                                ['avatar'] !=
                                                            ""
                                                        ? AssetImage(
                                                                'assets/loginRegister/avatars/${items[index]['avatar']}.png')
                                                            as ImageProvider // Provide a valid fallback asset
                                                        : NetworkImage(items[
                                                                index][
                                                            'avatarImage']), // Adjust size to match the image’s
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: IconButton(
                                                    onPressed: () async {
                                                      await showDialog<bool>(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                          title: const Text(
                                                              'Delete Profile'),
                                                          content: const Text(
                                                            'Are you sure you want to delete this profile?',
                                                            style: TextStyle(
                                                                fontSize: 15),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(); // Cancel
                                                              },
                                                              child: const Text(
                                                                  'No'),
                                                            ),
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                await deleteProfile(
                                                                    items[index]
                                                                        [
                                                                        'profile id']);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                        '${items[index]['name']} profile deleted'),
                                                                  ),
                                                                );
                                                              },
                                                              child: const Text(
                                                                  'Yes'),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.delete_forever,
                                                      color:
                                                          Colors.red.shade500,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 25,
                                                  left: 80,
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.55,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 12.0),
                                                          child: Text(
                                                            items[index]
                                                                ['name'],
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                        const Gap(7),
                                                        StreamBuilder<
                                                            DocumentSnapshot>(
                                                          stream: FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(userId)
                                                              .collection(
                                                                  'profiles')
                                                              .doc(items[index][
                                                                  'profile id'])
                                                              .collection(
                                                                  'LessonsFinished')
                                                              .doc(items[index]
                                                                  ['lesson id'])
                                                              .snapshots(),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return LinearPercentIndicator(
                                                                percent: 0,
                                                                animation: true,
                                                                animationDuration:
                                                                    900,
                                                                backgroundColor:
                                                                    Colors
                                                                        .blueGrey
                                                                        .shade100,
                                                                linearGradient:
                                                                    const LinearGradient(
                                                                  colors: [
                                                                    Color(
                                                                        0xFFFFD700), // Adjust colors
                                                                    Color(
                                                                        0xFF00FF00),
                                                                  ],
                                                                ),
                                                                lineHeight:
                                                                    10, // Smaller height for a sleeker look
                                                                barRadius:
                                                                    const Radius
                                                                        .circular(
                                                                        5),
                                                              );
                                                            }

                                                            if (!snapshot
                                                                    .hasData ||
                                                                !snapshot.data!
                                                                    .exists) {
                                                              return const Center(
                                                                child: Text(
                                                                    'Document does not exist'),
                                                              );
                                                            }

                                                            int age = int.parse(
                                                                items[index]
                                                                    ['age']);

                                                            List<int>
                                                                accessibleCategories =
                                                                [];
                                                            List<int>
                                                                subCategoriesMinus =
                                                                []; // FOR MINUS IN THE LENGTH OF CATEGORYLIST[INDEX]
                                                            if (age >= 2 &&
                                                                age <= 3) {
                                                              accessibleCategories =
                                                                  [
                                                                0
                                                              ]; // Letters
                                                              subCategoriesMinus =
                                                                  [
                                                                0,
                                                                0,
                                                                0,
                                                                0
                                                              ]; //
                                                            } else if (age >=
                                                                    4 &&
                                                                age <= 5) {
                                                              accessibleCategories =
                                                                  [
                                                                0,
                                                                1,
                                                                2
                                                              ]; // Letters, Words, Numbers
                                                              subCategoriesMinus =
                                                                  [
                                                                0,
                                                                1,
                                                                0,
                                                                0
                                                              ]; //
                                                            } else if (age >=
                                                                6) {
                                                              accessibleCategories =
                                                                  [
                                                                0,
                                                                1,
                                                                2,
                                                                3
                                                              ]; // All categories
                                                              subCategoriesMinus =
                                                                  [0, 0, 0, 0];
                                                            }

                                                            double
                                                                totalProgressValue =
                                                                0.0;
                                                            double
                                                                totalExpectedValue =
                                                                0.0;

                                                            for (int categoryIndex =
                                                                    0;
                                                                categoryIndex <
                                                                    categoryList
                                                                        .length;
                                                                categoryIndex++) {
                                                              double
                                                                  categoryProgressValue =
                                                                  0.0;
                                                              double
                                                                  categoryExpectedValue =
                                                                  0.0;

                                                              for (int progressItem =
                                                                      0;
                                                                  progressItem <
                                                                      categoryList[categoryIndex]
                                                                              .length -
                                                                          subCategoriesMinus[
                                                                              categoryIndex];
                                                                  progressItem++) {
                                                                double
                                                                    progress =
                                                                    double.parse(snapshot
                                                                            .data![categoryList[categoryIndex]
                                                                                [progressItem]
                                                                            .name] ??
                                                                        '0');
                                                                double total =
                                                                    categoryList[categoryIndex][progressItem]
                                                                            .total ??
                                                                        0;
                                                                categoryProgressValue +=
                                                                    progress;
                                                                categoryExpectedValue +=
                                                                    total;
                                                              }

                                                              totalProgressValue +=
                                                                  categoryProgressValue;
                                                              totalExpectedValue +=
                                                                  categoryExpectedValue;
                                                            }

                                                            double
                                                                totalProgress =
                                                                totalExpectedValue ==
                                                                        0
                                                                    ? 0
                                                                    : totalProgressValue /
                                                                        totalExpectedValue;

                                                            return LinearPercentIndicator(
                                                              percent:
                                                                  totalProgress,
                                                              animation: true,
                                                              animationDuration:
                                                                  900,
                                                              backgroundColor:
                                                                  Colors.grey
                                                                      .shade300,
                                                              linearGradient:
                                                                  const LinearGradient(
                                                                colors: [
                                                                  Color(
                                                                      0xFFFFD700),
                                                                  Color(
                                                                      0xFF00FF00),
                                                                ],
                                                              ),
                                                              lineHeight: 10,
                                                              barRadius:
                                                                  const Radius
                                                                      .circular(
                                                                      5),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
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
