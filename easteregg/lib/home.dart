import 'package:flutter/material.dart';
import 'package:meeting/login.dart';
import 'package:meeting/model/user_model.dart';
import 'package:meeting/services/api.dart';
import 'constants/color.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatelessWidget {
  Home();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/climate-change-logo.png',
                width: 100, height: 100),
            Row(
              children: [
                Container(
                    margin: EdgeInsets.only(right: 15),
                    child: Icon(
                      Icons.filter_list,
                      color: Colors.black,
                    )),
                Icon(Icons.notifications, color: Colors.black),
              ],
            )
          ],
        ),
      ),
      body: SliderWithImages(), // Specify the user ID here
      bottomNavigationBar: BottomRow(),
    );
  }
}

class SliderWithImages extends StatefulWidget {
  SliderWithImages();

  @override
  _SliderWithImagesState createState() => _SliderWithImagesState();
}

class _SliderWithImagesState extends State<SliderWithImages> {
  List<String> imageUrls = [];
  int currentIndex = 0;
  PageController pageController = PageController(initialPage: 0);
  var isloading = true;

  List<ProfileUser> pdata = [];
  List<bool> liked = [];

  // Variable to track whether the bottom sheet is currently open
  bool isBottomSheetOpen = false;

  // Create a ScrollController
  ScrollController _scrollController = ScrollController();
  bool showImage = false;
  int counter = 0;
  int counter2 = 0;
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    // Attach the scroll controller listener
    _scrollController.addListener(_scrollListener);
  }

  Future<void> checkLoginStatus() async {
    try {
      int loginStatus = await Api.loginsuccess();
      print(loginStatus);
      if (loginStatus == 1) {
        pdata = await Api.getProfileUser();
        for (var element in pdata) {
          liked.add(false);
        }
        setState(() {
          isloading = false;
        });
      } else if (loginStatus == 2) {
        Navigator.pushNamed(context, '/profileuser');
      } else if (loginStatus == 3) {
        Navigator.pushNamed(context, '/login');
      }
    } catch (error) {
      print("API Error: $error");
      Navigator.pushNamed(context, '/login');
    }
  }

  // Scroll controller listener
// Scroll controller listener
  void _scrollListener() {
    // Check if the user has scrolled to the bottom
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      // Show the bottom sheet if it's not already open
      if (!isBottomSheetOpen) {
        isBottomSheetOpen = true;
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            var index = 0; // Set the index based on your logic or requirements
            ProfileUser profile = pdata[index];

            return SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row with profile name
                  Row(
                    children: [
                      Text(
                        "${profile.firstname}" ?? 'no data',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(132, 50, 155, 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: liked[index] ? Colors.red : Colors.white,
                          ),
                          onPressed: () async {
                            if (!liked[index]) {
                              setState(() {
                                liked[index] = true;
                              });
                              await Future.delayed(Duration(seconds: 2));

                              setState(() {
                                pdata.removeAt(index);
                                liked.removeAt(index);
                              });

                              await Api.like(profile.user);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Row with icon and location text
                  Row(
                    children: [
                      Icon(Icons.location_on, color: mainColor),
                      Text('Paris, France'),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Horizontal line
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  // Text "About"
                  Text(
                    'About',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  // Row with "About" text
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Hello, my name is "${profile.firstname}" and I am an IT Engineer. '
                          'I have been working as a [job title] for [number of years] and I have been enjoying every '
                          'moment of it. I have always had a passion for [job title], and it is truly an honor to be able to work with such amazing people.',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Rows with additional information
                  buildInfoRow(
                      'FirstName', "${profile.firstname}" ?? 'no data'),
                  buildInfoRow('LastName', profile.lastname ?? 'no data'),
                  buildInfoRow('Phone', profile.phone ?? 'no data'),
                  buildInfoRow('Age', profile.age ?? 'no data'),
                  // buildInfoRow('Gender', profile.gender),
                  SizedBox(height: 16),
                  // Button with icon and "Message Now" text
                  Center(
                    child: Container(
                      width: 0.8 *
                          MediaQuery.of(context)
                              .size
                              .width, // Set width to 80% of the screen width
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle button press
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors
                              .purple, // Set button background color to purple
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.email,
                                color: Colors.white), // Set icon color to white
                            SizedBox(
                                width:
                                    16), // Increase the width of SizedBox for more space
                            Text(
                              'Message Now',
                              style: TextStyle(
                                  color:
                                      Colors.white), // Set text color to white
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
          },
        ).whenComplete(() {
          // Set isBottomSheetOpen to false when the bottom sheet is closed
          isBottomSheetOpen = false;
        });
      }
    }
  }

// Helper method to build rows with information
  Widget buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isloading) {
      return Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Container(
              color: Colors.black.withOpacity(0.4),
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to Easter Egg App!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't touch this button!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showImage = true;
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Image Affected'),
                                content: Column(
                                  children: [
                                    Image.asset('assets/pouletrire.jpg'),
                                    SizedBox(height: 25),
                                    Text('hhh, I deceived you',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          fontFamily: 'poppins',
                                        )),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        showImage = false;
                                      });
                                    },
                                    child: Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text("You will win"),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      setState(() {
                        counter2++;
                      });
                    },
                    child: Text(
                      'this is the answer',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showImage = true;
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Easter Egg Found!'),
                                content: Column(
                                  children: [
                                    Image.asset(
                                      'assets/eggs.avif',
                                      width: 500,
                                      height: 300,
                                    ),
                                    SizedBox(height: 16),
                                    Text("hhh, It's not you will try again??"),
                                    SizedBox(height: 16),
                                    Text(
                                      'Againnnn hayhay',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        showImage = false;
                                      });
                                    },
                                    child: Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text("You will win this time"),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  InkWell(
                    onTap: () {
                      setState(() {
                        counter++;
                      });
                      if (counter == 8) {
                        Navigator.pushNamed(context, '/goodgame');
                      }
                    },
                    child: Text(
                      'the sol is not here',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Message'),
                                content: Column(
                                  children: [
                                    Text(
                                      'Again haha',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Image.asset(
                                      'assets/fachepoulet.jpg',
                                      width: 300, // Adjust the width as needed
                                      height:
                                          300, // Adjust the height as needed
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Are You crazy mmmm',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text("No, don't believe"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: Text("Log Out"),
          ),
        ],
      ),
    );
  }
}

class BottomRow extends StatefulWidget {
  @override
  _BottomRowState createState() => _BottomRowState();
}

class _BottomRowState extends State<BottomRow> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("the answer didn't appear simply"),
          IconButton(
            icon: Icon(Icons.question_answer),
            onPressed: () {
              Navigator.pushNamed(context, '/findanswer');
            },
          ),
          IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.pushNamed(context, '/profileuserupdate');
              }),
        ],
      ),
    );
  }
}
