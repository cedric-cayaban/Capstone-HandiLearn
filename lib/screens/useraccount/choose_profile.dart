import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_drawing/data/userAccount.dart';
import 'package:test_drawing/screens/insideapp/home.dart';
import 'package:test_drawing/screens/useraccount/create_profile.dart';
import 'package:test_drawing/screens/useraccount/enterPin.dart';
import 'package:test_drawing/screens/useraccount/login.dart';

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
        title: Text(
          'User selection',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: SizedBox(),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
            icon: Icon(Icons.logout),
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
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/loginRegister/bg4.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(21.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Second container with GridView at the top
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
                      offset:
                          Offset(0, 3), // Changes the position of the shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: isLoaded
                          ? GridView.builder(
                              padding:
                                  EdgeInsets.all(8.0), // Add padding if needed
                              itemCount: items.length +
                                  1, // Add one extra item for the "Create Profile" button
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    2, // Number of columns in the grid
                                crossAxisSpacing:
                                    5, // Horizontal space between items
                                mainAxisSpacing:
                                    5, // Vertical space between items
                                childAspectRatio:
                                    1, // Aspect ratio of each item
                              ),
                              itemBuilder: (context, index) {
                                // If the index is the last item, show the "Create Profile" button
                                if (index == items.length) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => CreateProfile(),
                                        ),
                                      );
                                    },
                                    child: Card(
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
                                                fontSize: 16,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
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
                                      print(profileId);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => EnterPin(),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      elevation: 5,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                      shape: CircleBorder(),
                                      child: GridTile(
                                        footer: Text(
                                          items[index]['name'] ?? 'not given',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        child: items[index]['avatar'] != null
                                            ? Image.asset(
                                                'assets/loginRegister/avatars/${items[index]['avatar']}.png',
                                              )
                                            : CircularProgressIndicator(),
                                      ),
                                    ),
                                  );
                                }
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
