import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          actions: [
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                // Handle filter button press
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16), // Add top padding here
              child: SearchInput(),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 16),
                child: MessageList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SearchInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.search),
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search by name',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Replace with your actual data count
      itemBuilder: (context, index) {
        return MessageRow(
          imageUrl: 'https://example.com/avatar.png', // Replace with image URL
          firstName: 'John Doe', // Replace with first name
          message: 'Hello, how are you?', // Replace with message text
          time: '2:30 PM', // Replace with message time
          isLast: index == 9, // Check if it's the last item
        );
      },
    );
  }
}

class MessageRow extends StatelessWidget {
  final String imageUrl;
  final String firstName;
  final String message;
  final String time;
  final bool isLast;

  MessageRow({
    required this.imageUrl,
    required this.firstName,
    required this.message,
    required this.time,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Text(firstName),
          subtitle: Text(message),
          trailing: Text(time),
        ),
        if (!isLast) Divider(height: 1, color: Colors.grey),
      ],
    );
  }
}
