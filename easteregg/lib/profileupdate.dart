import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:meeting/home.dart';
import 'dart:io';

import 'package:meeting/login.dart';
import 'package:meeting/model/user_model.dart';
import 'package:meeting/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({super.key});

  @override
  State<ProfileUpdate> createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  final _formKey = GlobalKey<FormState>();
  var fnameController = TextEditingController();
  var lnameController = TextEditingController();
  var ageController = TextEditingController();
  var phoneController = TextEditingController();
  File? _image;
  File? _image1;
  File? _image2;
  File? _image3;
  File? _image4;
  var imagestatut = false;
  var imagestatut1 = false;
  var imagestatut2 = false;
  var imagestatut3 = false;

  var imagestatut4 = false;

  final picker = ImagePicker();
  List<String> imageUrls = [];
  ProfileUser? pdata; // Your list of user profiles
  var isloading = true; // Set to true to indicate data is loading

  @override
  void initState() {
    super.initState();
    // Load your data here
    loadData();
  }

  Future<void> loadData() async {
    // Simulate loading for 2 seconds

    // Replace this with your actual data retrieval code
    // For example, you can call Api.getProfileUser() here

    pdata = await Api.getProfileUserToUpdate();

    // Update the state to indicate data is loaded
    setState(() {
      isloading = false;
    });
  }

  Future<void> _pickImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    print('hohu');
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse(
          '${Api.baseUrl}update_profileuser'), // Replace with your server URL
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, String> headers = {
      'Authorization': token.toString(),
      'Content-Type': 'application/json', // Adjust the content type if needed
    };
    // Set headers here
    request.headers.addAll(headers);
    if (_image != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', _image!.path),
      );
    }
    if (_image1 != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image1', _image1!.path));
    }
    if (_image2 != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image2', _image2!.path));
    }
    if (_image3 != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image3', _image3!.path));
    }

    if (_image4 != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image4', _image4!.path));
    }

    // Add data fields to the request
    request.fields['fname'] = fnameController.text;
    request.fields['lname'] = lnameController.text;
    request.fields['age'] = ageController.text;
    request.fields['phone'] = phoneController.text;

    request.fields['image0'] = (imagestatut ? 'true' : 'false');
    request.fields['image1'] = (imagestatut1 ? 'true' : 'false');
    request.fields['image2'] = (imagestatut2 ? 'true' : 'false');
    request.fields['image3'] = (imagestatut3 ? 'true' : 'false');
    request.fields['image4'] = (imagestatut4 ? 'true' : 'false');

    var response = await request.send();
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${await response.stream.bytesToString()}');
    if (response.statusCode == 200) {
      print('Image uploaded successfully');

      // Check if the profile is already registered

      // Profile is already registered, navigate to Home
      // Navigator.pushNamed(context, '/profileuserupdate');
    } else {
      print('Image upload failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isloading) {
      return Center(child: CircularProgressIndicator());
    }

    if (pdata == null) {
      // Handle the case when no data is available
      return Center(child: Text('No data available'));
    }
    final imageUrls = pdata != null ? pdata!.image : [];
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile Update'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(45, 50, 45, 40),
                  height: 180,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/climate-change-logo.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromRGBO(209, 214, 217, 0.6),
                            ),
                            child: TextFormField(
                              controller: fnameController,
                              minLines: 1,
                              maxLines: 1,
                              decoration: InputDecoration(
                                labelText: '${pdata?.firstname}',
                                labelStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black.withOpacity(0.4),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                prefixIcon: const Icon(Icons.home_filled),
                                prefixIconColor: Colors.green,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  fnameController.text = '${pdata?.firstname}';
                                  // return 'Please enter your Firstname';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromRGBO(209, 214, 217, 0.6),
                            ),
                            child: TextFormField(
                              controller: lnameController,
                              minLines: 1,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: '${pdata?.lastname}',
                                labelStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.4),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                prefixIcon: const Icon(Icons.abc),
                                prefixIconColor: Colors.green,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  lnameController.text = '${pdata?.lastname}';
                                  // return 'Please enter your LastName';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromRGBO(209, 214, 217, 0.6),
                            ),
                            child: TextFormField(
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.4),
                              ),
                              controller: phoneController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  phoneController.text = '${pdata?.phone}';
                                  // return 'Please enter your phone number';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: '${pdata?.phone}',
                                labelStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black.withOpacity(0.4),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                prefixIcon: const Icon(Icons.phone),
                                prefixIconColor: Colors.green,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromRGBO(209, 214, 217, 0.6),
                            ),
                            child: TextFormField(
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.4),
                              ),
                              controller: ageController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  ageController.text = '${pdata?.age}';
                                  //return 'Please enter your age';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: '${pdata?.age}',
                                labelStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black.withOpacity(0.4),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                prefixIcon: const Icon(
                                  Icons.apps_outage_outlined,
                                ),
                                prefixIconColor: Colors.green,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                              onTap: () async {
                                final pickedImage = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (pickedImage != null) {
                                  setState(() {
                                    _image = File(pickedImage.path);
                                    imagestatut = true;
                                  });
                                }
                              },
                              child: Center(
                                child: Container(
                                    margin: const EdgeInsets.fromLTRB(
                                      10,
                                      10,
                                      15,
                                      10,
                                    ),
                                    height: 400,
                                    width: 1000,
                                    child: _image == null
                                        ? imageUrls.length > 0
                                            ? Image.network(
                                                '${Api.baseUrl}uploads/${imageUrls[0].toString()}',
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit
                                                    .cover, // Maintain aspect ratio and cover the container
                                              )
                                            : Image.asset("assets/upload.png")
                                        : Image.file(
                                            File(_image!.path),
                                          )),
                              )),
                          InkWell(
                            onTap: () async {
                              final pickedImage = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (pickedImage != null) {
                                setState(() {
                                  _image1 = File(pickedImage.path);
                                  imagestatut1 = true;
                                });
                              }
                            },
                            child: Center(
                              child: Container(
                                  margin: const EdgeInsets.fromLTRB(
                                    10,
                                    10,
                                    15,
                                    10,
                                  ),
                                  height: 400,
                                  width: 1000,
                                  child: _image1 == null
                                      ? imageUrls.length > 1
                                          ? Image.network(
                                              '${Api.baseUrl}uploads/${imageUrls[1].toString()}',
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit
                                                  .cover, // Maintain aspect ratio and cover the container
                                            )
                                          : Image.asset("assets/upload.png")
                                      : Image.file(
                                          File(_image1!.path),
                                        )),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final pickedImage = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (pickedImage != null) {
                                setState(() {
                                  _image2 = File(pickedImage.path);
                                  imagestatut2 = true;
                                });
                              }
                            },
                            child: Center(
                              child: Container(
                                  margin: const EdgeInsets.fromLTRB(
                                    10,
                                    10,
                                    15,
                                    10,
                                  ),
                                  height: 400,
                                  width: 1000,
                                  child: _image2 == null
                                      ? imageUrls.length > 2
                                          ? Image.network(
                                              '${Api.baseUrl}uploads/${imageUrls[2].toString()}',
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit
                                                  .cover, // Maintain aspect ratio and cover the container
                                            )
                                          : Image.asset("assets/upload.png")
                                      : Image.file(
                                          File(_image2!.path),
                                        )),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final pickedImage = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (pickedImage != null) {
                                setState(() {
                                  _image3 = File(pickedImage.path);
                                  imagestatut3 = true;
                                });
                              }
                            },
                            child: Center(
                              child: Container(
                                  margin: const EdgeInsets.fromLTRB(
                                    10,
                                    10,
                                    15,
                                    10,
                                  ),
                                  height: 400,
                                  width: 1000,
                                  child: _image3 == null
                                      ? imageUrls.length > 3
                                          ? Image.network(
                                              '${Api.baseUrl}uploads/${imageUrls[3].toString()}',
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit
                                                  .cover, // Maintain aspect ratio and cover the container
                                            )
                                          : Image.asset("assets/upload.png")
                                      : Image.file(
                                          File(_image3!.path),
                                        )),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final pickedImage = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (pickedImage != null) {
                                setState(() {
                                  _image4 = File(pickedImage.path);
                                  imagestatut4 = true;
                                });
                              }
                            },
                            child: Center(
                              child: Container(
                                  margin: const EdgeInsets.fromLTRB(
                                    10,
                                    10,
                                    15,
                                    10,
                                  ),
                                  height: 400,
                                  width: 1000,
                                  child: _image4 == null
                                      ? imageUrls.length > 4
                                          ? Image.network(
                                              '${Api.baseUrl}uploads/${imageUrls[4].toString()}',
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit
                                                  .cover, // Maintain aspect ratio and cover the container
                                            )
                                          : Image.asset("assets/upload.png")
                                      : Image.file(
                                          File(_image4!.path),
                                        )),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    var data = {
                                      "fname": fnameController.text,
                                      "lname": lnameController.text,
                                      "age": ageController.text,
                                      "phone": phoneController.text,
                                    };
                                    await _uploadImage();
                                    // Call your API to save the user data
                                    // For example:
                                    // Api.addProfileUser(data);
                                  }
                                },
                                child: const Text('Update'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyLoginPage(),
                                    ),
                                  );
                                },
                                child: Text("Log Out"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
