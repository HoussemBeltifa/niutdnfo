import 'package:flutter/material.dart';
import 'package:meeting/login.dart';
import 'package:meeting/model/user_model.dart';
import 'package:meeting/services/api.dart';
import 'constants/color.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';

class LikedPerson extends StatelessWidget {
  LikedPerson();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/logo.png', width: 100, height: 100),
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

  @override
  void initState() {
    super.initState();
    getlikes();
  }

  Future<void> getlikes() async {
    try {
      pdata = await Api.getlikes();
      for (var element in pdata) {
        liked.add(true);
      }
      setState(() {
        isloading = false;
      });
    } catch (error) {
      // Handle any errors that occurred during the API call
      print("API Error: $error");
      // Handle the error case
    }
  }

/*
  Future<void> fetchImageUrls() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.3/uploads/'));
      if (response.statusCode == 200) {
        final List<dynamic> imageUrlsJson = json.decode(response.body);
        setState(() {
          imageUrls = imageUrlsJson.cast<String>();
        });
      } else {
        throw Exception('Failed to load image URLs');
      }
    } catch (error) {
      print('Error fetching image URLs: $error');
    }
  }
*/

  @override
  Widget build(BuildContext context) {
    if (isloading) {
      return (Center(child: CircularProgressIndicator()));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Container(
              color: Colors.black.withOpacity(0.4),
              padding: EdgeInsets.all(8),
              child: pdata.length > 0
                  ? CarouselSlider.builder(
                      itemCount: pdata.length,
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        ProfileUser profile = pdata[index];

                        print(profile.image);
                        List imageUrls = profile.image;

                        return Column(
                          children: [
                            Container(
                              height: 400,
                              child: PageView.builder(
                                itemCount: imageUrls.length,
                                itemBuilder: (context, indexa) {
                                  return Image.network(
                                    '${Api.baseUrl}uploads/${imageUrls[indexa].toString()}',
                                    width: 500,
                                    height: 350,
                                  );
                                },
                              ),
                            ),
                            Text(
                              "${profile.firstname}",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 5),
                                  child: Icon(
                                    Icons.location_on,
                                    size: 30,
                                    color: mainColor,
                                  ),
                                ),
                                Text("${profile.lastname}"),
                                Text(
                                  '  Paris, France',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Icon(Icons.star, size: 16, color: Colors.white),
                                Text(
                                  '3.5 km',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.cancel,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(132, 50, 155, 1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.favorite,
                                        color: liked[index]
                                            ? Colors.red
                                            : Colors.white,
                                      ),
                                      onPressed: () async {
                                        if (liked[index]) {
                                          setState(() {
                                            liked[index] = false;
                                          });
                                          // Remove the current profile from the list
                                          await Future.delayed(
                                              Duration(seconds: 2));

                                          // Remove the current profile from the list
                                          setState(() {
                                            pdata.removeAt(index);
                                            liked.removeAt(index);
                                          });

                                          // Call the API to handle the "Like" action
                                          await Api.dislike(profile.user);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                      options: CarouselOptions(
                        height: 600, // Set the desired height
                        enlargeCenterPage: true,
                        viewportFraction: 1,
                        autoPlay: false,
                        autoPlayInterval: Duration(seconds: 3),
                      ),
                    )
                  : Center(child: Text('no data')),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: Text("log out"),
          ),
        ],
      ),
    );
  }
}

class BottomRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(icon: Icon(Icons.location_on), onPressed: () {Navigator.pushNamed(context, '/');}),
          IconButton(
              icon: Icon(Icons.email),
              onPressed: () {
                Navigator.pushNamed(context, '/chatlist');
              }),
          IconButton(icon: Icon(Icons.favorite), onPressed: () {}),
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
