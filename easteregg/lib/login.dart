import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:meeting/chatlist.dart';
import 'package:meeting/chatscreen.dart';
import 'package:meeting/fetch.dart';
import 'package:meeting/home.dart';
import 'dart:convert';

import 'package:meeting/profilecreation.dart';
import 'package:meeting/services/api.dart';
import 'package:meeting/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key}) : super(key: key);

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  bool _isObscure = true;

  final _formKey = GlobalKey<FormState>();
  SharedPreferences? prefs = null;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  // Load the user name from shared preferences
  _loadUserName() async {
    prefs = await SharedPreferences.getInstance();
  }
showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
  Future<void> loginUser(
      BuildContext context, String email, String password) async {
    try {
      showLoaderDialog(context);
      final response = await http.post(
        Uri.parse(
            '${Api.baseUrl}login'), // Replace with your actual backend URL
        body: {
          'email': email,
          'password': password,
        },
      );
      Navigator.pop(context);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final token = responseBody['token'];
        final userId =
            responseBody['userId']; // Adjust this to match your API response

        print('Login successful. Token: $token, UserId: $userId');
        print(responseBody['profile']);
        await prefs?.setString('token', token);
        // Store the token securely and navigate to the home screen
        if (responseBody['profile'] == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileCreation(),
            ),
          );
        }
      } else {
        final responseBody = json.decode(response.body);
        final errorMessage = responseBody['message'];
        print('Login failed. Error: $errorMessage');

        ScaffoldMessenger.of(context).showSnackBar(
          
          SnackBar(
            duration: Duration(seconds: 2),
            content: Text(errorMessage),
          ),
        );
      }
    } catch (error) {
      print('Error during login: $error');
      // Handle the error here, such as showing an error message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred during login.'),
        ),
      );
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        print('Google Sign In Success: ${googleUser.displayName}');
        // Perform your registration or navigation logic here
      }
    } catch (error) {
      print('Google Sign In Error: $error');
    }
  }

  Future<void> _handleFacebookSignIn() async {
    try {
      final LoginResult result = await _facebookAuth.login();
      if (result.status == LoginStatus.success) {
        final AccessToken? accessToken = result.accessToken;
        print('Facebook Sign In Success: ${accessToken?.userId}');
        // Perform your registration or navigation logic here
      }
    } catch (error) {
      print('Facebook Sign In Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20), // Adjust the padding as needed
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(
                      0, 20, 0, 20), // Adjust the margin as needed
                  height: 180,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/climatechange.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Row(
                  children: [Text(('Login Account'),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,fontFamily: 'poppins'))],
                ),
                SizedBox(height: 15),
                Form(
                    key: _formKey,
                    child: Column(children: [
                      Row(children: [Text("Please Login with registered account",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,fontFamily: 'poppins',
                      color: Colors.black.withOpacity(0.4)
                      ))]),
                        SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [Text("Email :",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,fontFamily: 'poppins'),),],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color.fromRGBO(209, 214, 217, 0.6),
                        ),
                        child: TextFormField(
                          controller: emailController,
                          minLines: 1,
                          maxLines: 1,
                          decoration: InputDecoration(
                              hintText: 'Email',
                            /*labelText: 'Email',
                            labelStyle: TextStyle(
                              color: Colors.black.withOpacity(0.4),
                            ),*/
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
                            prefixIcon: const Icon(Icons.email),
                            prefixIconColor:
                                Colors.green, // Use your preferred color
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                                    .hasMatch(value!)) {
                              return 'Please enter your correct email';
                            }
                            return null;
                          },
                        ),


                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [Text("Password :",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,fontFamily: 'poppins'),)],
                      ),
                      SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color.fromRGBO(209, 214, 217, 0.6),
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Password';
                            }
                            return null;
                          },
                          obscureText: _isObscure,
                          
                          decoration: InputDecoration(
                            hintText: 'Password',
                            /*labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Colors.black.withOpacity(0.4),
                            ),*/
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
                            prefixIcon: const Icon(Icons.lock),
                            prefixIconColor:
                                Colors.green, // Use your preferred color
                            suffixIcon: IconButton(
                              icon: Icon(_isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child:ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor:Colors.green,padding: EdgeInsets.all(10)),
                              
                              onPressed: () async {
                               
                                if (_formKey.currentState!.validate()) {
                                  final email = emailController.text;
                                  final password = passwordController.text;
                                  await loginUser(context, email, password);
                                }
                                
                              },
                           
                              child: Text('Sign In',style: TextStyle(fontFamily: 'poppins',fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
                            ),
                          )
                        ],
                      ),
                    
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account ?",style: TextStyle(fontFamily: 'poppins',fontWeight: FontWeight.bold),),
                          Container(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUp(),
                                  ),
                                );
                              },
                              child: Text("Sign Up",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 17)),
                            ),
                          )
                        ],
                      ),
                    ])),
                SizedBox(height: 20),
               
                Divider(
                  color: Colors.grey, // Line color
                  thickness: 1, // Line thickness
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _handleGoogleSignIn,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(12)
                      // primary: Colors.black, // Background color
                      ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                   
                      Image.asset(
                        'assets/googleduck.png',
                        width: 30, // Adjust the width and height as needed
                        height: 24,
                      ),

                      SizedBox(
                          width: 24), // Add spacing between the image and text
                      Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,

                          color: Colors.black, // Text color
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _handleFacebookSignIn,
                  style: ElevatedButton.styleFrom(
                       padding: EdgeInsets.all(10)
                      // primary: Colors.black, // Background color
                      ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
          
                      Icon(Icons.facebook, color: Colors.blue, size: 30),
                      SizedBox(
                          width: 15), // Add spacing between the image and text
                      Text(
                        ' Continue with Facebook',
                        
                         style: TextStyle(
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,

                          color: Colors.black, // Text color
                        ),
                      ),
                    ],
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
