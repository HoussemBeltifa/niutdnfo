import 'package:flutter/material.dart';
import 'package:meeting/login.dart';

class TestVerification extends StatefulWidget {
  const TestVerification({super.key});

  @override
  State<TestVerification> createState() => _TestVerificationState();
}

class _TestVerificationState extends State<TestVerification> {
  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
                    padding:
                        const EdgeInsets.all(5), // Adjust the padding as needed
                    child: Column(children: [
                      Text(('Verification'),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              fontFamily: 'poppins')),
                      Text("Please Check your phone Number",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: 'poppins',
                              color: Colors.black.withOpacity(0.4))),
                      SizedBox(
                        height: 150,
                      ),
                      Container(
                        width: 100, // Adjust the width to make it larger
                        height: 100, // Adjust the height to make it larger
                        decoration: BoxDecoration(
                          color: Colors
                              .purple, // Set the background color to purple
                          borderRadius:
                              BorderRadius.circular(50), // Make it rounded
                        ),
                        child: Center(
                          child: Icon(
                            Icons.email,
                            color: Colors.white, // Set the icon color to white
                            size: 48, // Adjust the size of the icon as needed
                          ),
                        ),
                      ),
                      Column(children: [
                        Text(('Verification Code'),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                fontFamily: 'poppins')),
                        Text("We have sent a verification code to +216...",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                fontFamily: 'poppins',
                                color: Colors.black.withOpacity(0.4))),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: _buildSquare(' here the 1'
                               /* TextField(
                                  controller: _controller,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Enter a single digit',
                                  ),
                                  onChanged: (value) {
                                    if (value.length > 1) {
                                      _controller.text = value.substring(0, 1);
                                      _controller.selection =
                                          TextSelection.fromPosition(
                                        TextPosition(offset: 1),
                                      );
                                    }
                                  },
                                ),  */
                              ),
                            ),
                            _buildSquare("2"),
                            _buildSquare("3"),
                            _buildSquare("4"),
                          ],
                        )
                      ]),
                      SizedBox(
                        height: 150,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  padding: EdgeInsets.all(10)),
                              onPressed: () async {},
                              child: Text(
                                'Submit',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't receive the code ?",
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
                                    builder: (context) => MyLoginPage(),
                                  ),
                                );
                              },
                              child: Text("Resend",
                                  style: TextStyle(
                                      fontFamily: 'poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17)),
                            ),
                          )
                        ],
                      ),
                    ])))));
  }
}

Widget _buildSquare(String text) {
  return Container(
    width: 50, // Adjust the size of the square as needed
    height: 50,
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.black, // Border color
        width: 2.0, // Border width
      ),
      borderRadius: BorderRadius.circular(8), // Make it rounded
    ),
    child: Center(
      child: TextField(
       // keyboardAppearance: TextInputType,number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(counterText: ""),
        
        style: TextStyle(

          fontFamily: 'poppins',
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    ),
  );
}
