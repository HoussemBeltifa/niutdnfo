import 'package:flutter/material.dart';

class GoodGame extends StatefulWidget {
  @override
  _GoodGameState createState() => _GoodGameState();
}

class _GoodGameState extends State<GoodGame> {
  int counter = 0;
  int clickCounter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Good Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Counter: $counter',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  counter = 0;
                  clickCounter = 0; // Reset both counters
                });
                Navigator.pushNamed(
                    context, '/login'); // Navigate to login page
              },
              child: Text('Play Again'),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () {
                setState(() {
                  clickCounter++;
                });
                if (clickCounter == 3) {
                  // Show the congratulatory message with an image
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Congratulations!'),
                        content: Column(
                          children: [
                            Text(
                              'You have discovered the secret information Congratulationsssssss.',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Image.asset(
                              'assets/congratulations_image.png', // Replace with your image asset
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 28),
                            Image.asset(
                              'assets/egggold.jpg', // Replace with your image asset
                              width: 100,
                              height: 100,
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
                }
              },
              child: Text(
                'Click me 3 times for a secret!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
