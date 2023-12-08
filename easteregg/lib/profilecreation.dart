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

class ProfileCreation extends StatefulWidget {
  ProfileCreation();

  @override
  State<ProfileCreation> createState() => _ProfileCreationState();
}

class _ProfileCreationState extends State<ProfileCreation> {
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

  final picker = ImagePicker();
  List<String> imageUrls = []; // Declare the imageUrls variable here

  Future<void> _pickImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image != null) {
      print('hohu');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${Api.baseUrl}add_profileuser'), // Replace with your server URL
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      Map<String, String> headers = {
        'Authorization': token.toString(),
        'Content-Type': 'application/json', // Adjust the content type if needed
      };
      // Set headers here
      request.headers.addAll(headers);
      request.files.add(
        await http.MultipartFile.fromPath('image', _image!.path),
      );
      if (_image1 != null) {
        await http.MultipartFile.fromPath('image1', _image1!.path);
      }
      if (_image2 != null) {
        await http.MultipartFile.fromPath('image2', _image2!.path);
      }
      if (_image3 != null) {
        await http.MultipartFile.fromPath('image3', _image3!.path);
      }

      if (_image4 != null) {
        await http.MultipartFile.fromPath('image4', _image4!.path);
      }

      // Add data fields to the request
      request.fields['fname'] = fnameController.text;
      request.fields['lname'] = lnameController.text;
      request.fields['age'] = ageController.text;
      request.fields['phone'] = phoneController.text;

      var response = await request.send();
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${await response.stream.bytesToString()}');
      if (response.statusCode == 200) {
        print('Image uploaded successfully');

        // Check if the profile is already registered

        // Profile is already registered, navigate to Home
        Navigator.pushNamed(context, '/');
      } else {
        print('Image upload failed');
      }
    } else {
      print('Please pick an image first');
    }
  }

  Future<bool> profileDataIsAvailable() async {
    try {
      // Make an asynchronous call to getProfileUser
      List<ProfileUser> prodata = await Api.getProfileUser();

      // Check if the prodata list is not empty
      return prodata.isNotEmpty;
    } catch (error) {
      // Handle any potential errors, e.g., network issues
      print('Error checking profile data: $error');
      return false; // Return false in case of an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                                labelText: 'First Name',
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
                                  return 'Please enter your Firstname';
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
                                labelText: 'Last Name',
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
                                  return 'Please enter your LastName';
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
                                  return 'Please enter your phone number';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
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
                                  return 'Please enter your age';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Age',
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
                                });
                              }
                            },
                            child: Center(
                              child: _image != null
                                  ? Image.file(
                                      File(_image!.path),
                                    )
                                  : Image.asset("assets/upload.png"),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final pickedImage = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (pickedImage != null) {
                                setState(() {
                                  _image1 = File(pickedImage.path);
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
                                child: _image1 != null
                                    ? Image.file(
                                        File(_image1!.path),
                                      )
                                    : Image.asset("assets/upload.png"),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final pickedImage = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (pickedImage != null) {
                                setState(() {
                                  _image2 = File(pickedImage.path);
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
                                child: _image2 != null
                                    ? Image.file(
                                        File(_image2!.path),
                                      )
                                    : Image.asset("assets/upload.png"),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final pickedImage = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (pickedImage != null) {
                                setState(() {
                                  _image3 = File(pickedImage.path);
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
                                child: _image3 != null
                                    ? Image.file(
                                        File(_image3!.path),
                                      )
                                    : Image.asset("assets/upload.png"),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final pickedImage = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (pickedImage != null) {
                                setState(() {
                                  _image4 = File(pickedImage.path);
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
                                child: _image4 != null
                                    ? Image.file(
                                        File(_image4!.path),
                                      )
                                    : Image.asset("assets/upload.png"),
                              ),
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
                                child: const Text('Submit'),
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
        ),
      ),
    );
  }
}
