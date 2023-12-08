import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:meeting/services/api.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<dynamic> users = []; // Store user data from the backend

  @override
  void initState() {
    super.initState();
    // Fetch the list of users from the backend when the screen is loaded
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response =
        await http.get(Uri.parse('${Api.baseUrl}get_user'));
    if (response.statusCode == 200) {
      final List<dynamic> userJson = json.decode(response.body);
      setState(() {
        users = userJson;
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user['name']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatttttttScreen(
                    userId: user['_id'],
                    userName: user['name'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ChatttttttScreen extends StatefulWidget {
  final String userId;
  final String userName;

  ChatttttttScreen({required this.userId, required this.userName});

  @override
  _ChatttttttScreenState createState() => _ChatttttttScreenState();
}

class _ChatttttttScreenState extends State<ChatttttttScreen> {
  List<dynamic> messages = []; // Store chat messages

  @override
  void initState() {
    super.initState();
    // Fetch chat messages between the logged-in user and the selected user
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.10/api/get_messages/${widget.userId}'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> messageJson = json.decode(response.body);
      setState(() {
        messages = messageJson;
      });
    } else {
      throw Exception('Failed to load messages');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message['messageText']),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      // Implement message input
                      ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Implement sending message logic
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
