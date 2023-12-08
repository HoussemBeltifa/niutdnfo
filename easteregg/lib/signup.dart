import 'package:flutter/material.dart';
import 'package:meeting/login.dart';
import 'package:meeting/services/api.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isObscure = true;
  bool _isObscureconfirmpassword = true;
  final _formKey = GlobalKey<FormState>();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  var fnameController = new TextEditingController();
  var lnameController = new TextEditingController();
  var emailController = new TextEditingController();
  var passwordController = new TextEditingController();
  var confirmpasswordController = new TextEditingController();

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
                    padding: const EdgeInsets.all(15),
                    child: Column(children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(45, 50, 45, 40),
                        height: 180,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/climatechange.png"),
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
                                Row(
                                  children: [
                                    Text(('Register Account'),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                            fontFamily: 'poppins'))
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                /*  Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color:
                                          Color.fromRGBO(209, 214, 217, 0.6)),
                                  child: TextFormField(
                                    //   style: TextStyle(color: Colors.green),
                                    controller: fnameController,
                                    // minLines: 1,
                                    // maxLines: 5,
                                    decoration: InputDecoration(
                                        labelText: 'First Name',
                                        labelStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black.withOpacity(0.4),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1, color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1, color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        prefixIcon:
                                            const Icon(Icons.home_filled),
                                        prefixIconColor: Colors.green),
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
                                      color:
                                          Color.fromRGBO(209, 214, 217, 0.6)),
                                  child: TextFormField(
                                    //  style: TextStyle(color: Colors.green),
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
                                              width: 1, color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1, color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        prefixIcon: const Icon(Icons.abc),
                                        prefixIconColor: Colors.green),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your LastName';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
*/
// ... (rest of the code)
                                Row(
                                  children: [
                                    Text(
                                      "Email :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          fontFamily: 'poppins'),
                                    ),
                                  ],
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
                                      prefixIconColor: Colors
                                          .green, // Use your preferred color
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
                                  children: [
                                    Text(
                                      "Password :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          fontFamily: 'poppins'),
                                    )
                                  ],
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
                                      prefixIconColor: Colors
                                          .green, // Use your preferred color
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
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Confirm Password :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          fontFamily: 'poppins'),
                                    )
                                  ],
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
                                    controller: confirmpasswordController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Confirm your Password';
                                      }
                                      return null;
                                    },
                                    obscureText: _isObscureconfirmpassword,
                                    decoration: InputDecoration(
                                      hintText: 'confirm Password',
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
                                      prefixIconColor: Colors
                                          .green, // Use your preferred color
                                      suffixIcon: IconButton(
                                        icon: Icon(_isObscureconfirmpassword
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                        onPressed: () {
                                          setState(() {
                                            _isObscureconfirmpassword =
                                                !_isObscureconfirmpassword;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Don't have an account ?",
                                          style: TextStyle(
                                              fontFamily: 'poppins',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyLoginPage(),
                                                ),
                                              );
                                            },
                                            child: Text("Sign In",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17)),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                padding: EdgeInsets.all(10)),
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                      .validate() &&
                                                  (confirmpasswordController
                                                          .text ==
                                                      passwordController
                                                          .text)) {
                                                var data = {
                                                  "email": emailController.text,
                                                  "password":
                                                      passwordController.text,
                                                };
                                                print(data);
                                                Api.addUser(data);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content:
                                                        Text('Processing Data'),
                                                  ),
                                                );
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MyLoginPage()),
                                                );
                                              }
                                            },
                                            child: Text(
                                              'Sign Up',
                                              style: TextStyle(
                                                  fontFamily: 'poppins',
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Divider(
                                  color: Colors.grey, // Line color
                                  thickness: 1, // Line thickness
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: _handleGoogleSignIn,
                                  style: ElevatedButton.styleFrom(
                                      // primary: Colors.black, // Background color
                                      ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 24),
                                      Image.asset(
                                        'assets/googleduck.png',
                                        width:
                                            30, // Adjust the width and height as needed
                                        height: 24,
                                      ),

                                      SizedBox(
                                          width:
                                              24), // Add spacing between the image and text
                                      Text(
                                        'Sign Up with Google',
                                        style: TextStyle(
                                          color: Colors.black, // Text color
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                ElevatedButton(
                                  onPressed: _handleFacebookSignIn,
                                  style: ElevatedButton.styleFrom(
                                      // primary: Colors.black, // Background color
                                      ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 36),
                                      Icon(Icons.facebook,
                                          color: Colors.blue, size: 34),
                                      SizedBox(
                                          width:
                                              15), // Add spacing between the image and text
                                      Text(
                                        ' Sign Up with Facebook',
                                        style: TextStyle(
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
                    ])))));
  }
}
