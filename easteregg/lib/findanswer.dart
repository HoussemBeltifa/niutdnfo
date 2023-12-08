import 'package:flutter/material.dart';

class FindAnswer extends StatefulWidget {
  @override
  _FindAnswerState createState() => _FindAnswerState();
}

class _FindAnswerState extends State<FindAnswer> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Answer'),
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
                  counter++;
                });
              },
              child: Text('Increment Counter'),
            ),
            Text(
              'The answer is simple but you should pop(retour) click in  trys your mind to work',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
