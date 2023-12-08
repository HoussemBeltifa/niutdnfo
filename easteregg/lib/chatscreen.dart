import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meeting/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String id; // Add the id parameter

  ChatScreen(this.id); // Update the constructor
  @override
  _ChatScreenState createState() => _ChatScreenState(id);
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  final String id; // Add the id parameter

  _ChatScreenState(this.id); // Update the constructor
  var index = 15;
  TextEditingController _messageController = TextEditingController();
  List _messages = []; // Change this to match your message structure
  var name = '';
  var prename = '';
  var photo = "";
  var _id = '';
  var iduser = '';
  var senderIdController = new TextEditingController();
  var receiverIdController = new TextEditingController();
  var messageTextController = new TextEditingController();
  var isloading = true;
  var loadingmessages = false;
  var lenmsg = 0;
  ScrollController _scrollController =
      ScrollController(); // Add ScrollController

  void _scrollToBottom() {
    print(_scrollController.position.maxScrollExtent);
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 40),
      curve: Curves.easeOut,
    );
  }

  void getanother() async {
    var results = await Api.getmessagat(index, _id);
    if (results['state']) {
      var messz = new List.from(results['messages']);

      index = index + 15;

      setState(() {
        _messages.addAll(messz);

        loadingmessages = false;
      });
    } else {
      loadingmessages = false;
    }
  }

  // Function to send a message
  Future<void> _sendMessage(String messageText) async {
    // Replace with your API endpoint to send a message
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Check if the token is null or empty and return an appropriate value

    Map<String, String> headers = {
      'Authorization': token.toString(),

      // Adjust the content type if needed
    };
    setState(() {
      _messages.add({
        'senderId': senderIdController.text, // Set the sender ID here
        'receiverId': receiverIdController.text, // Set the receiver ID here
        'messageText': messageText,
        // Replace with your server's timestamp field
      });
    });
    index = index + 1;
    _messageController.clear();
    await Future.delayed(Duration(milliseconds: 100)).then((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    });
    final apiUrl = Uri.parse('${Api.baseUrl}send_message/${_id}');

    try {
      final response = await http.post(apiUrl,
          body: {
            // Replace with your request parameters (sender, receiver, message text)
            'messageText': messageText,
          },
          headers: headers);

      if (response.statusCode == 200) {
        // Message sent successfully
        final data = jsonDecode(response.body);

        socket.emit(
            'sendmessage',
            jsonEncode({
              'senderId': iduser, // Set the sender ID here
              'messageText': messageText,
              'time': data[
                  'timestamp'], // Replace with your server's timestamp field
            }));
      } else {
        print('Failed to send message: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending message: $error');
    }
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Handle the selected image (e.g., upload it to your server)
      final file = File(pickedFile.path);

      // Call your image upload function here and pass 'file'
      // Example: await uploadImageToServer(file);
    }
  }

/*
  Future<void> _sendImage(String messageText, File imageFile) async {
    final apiUrl = Uri.parse('http://192.168.1.1/send_message');

    try {
      final request = http.MultipartRequest('POST', apiUrl);

      // Add form fields to the request
      request.fields['senderId'] = 'senderUserId';
      request.fields['receiverId'] = 'receiverUserId';
      request.fields['messageText'] = messageText;

      // Add the image file to the request
      request.files.add(await http.MultipartFile.fromPath(
        'image', // Replace with the name your server expects
        imageFile.path, // Path to the selected image file
        filename: 'selected_image.jpg', // Set the desired filename
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        // Handle successful image upload
      } else {
        print('Failed to send message: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending message: $error');
    }
  }
*/
  void _onScrollEvent() {
    final extentAfter = _scrollController.position.extentAfter;
    if (extentAfter == 0.0) {
      if (!loadingmessages && index < lenmsg) {
        setState(() {
          loadingmessages = true;
        });
        getanother();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrollEvent);

    socket = IO.io(Api.baseUrl, <String, dynamic>{
      'transports': ['websocket']
    });
    socket.connect();

    socket.onConnectError((error) {
      print('Error connecting to Socket.IO server: $error');
    });

    socket.onConnectTimeout((data) {
      print('Connection to Socket.IO server timed out.');
    });

    getmessages();

    socket.on('receivemessage', (data) async {
      var messagat = _messages;
      final datez = jsonDecode(data);
      index = index + 1;

      messagat.add({
        "createdAt": datez['createdAt'] ?? '',
        "messageText": datez['messageText'],
        "senderId": datez['senderId'],
      });
      setState(() {
        _messages = messagat;
      });
      await Future.delayed(Duration(milliseconds: 100)).then((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      });
    });
    // Connect to the Socket.IO server
    // Register event listeners
    socket.onConnect((_) {
      print('Connected');
    });

    socket.onDisconnect((_) {
      print('Disconnected');
    });

    socket.on('message', (data) {
      print('Received message: $data');
    });
  }

  Future<void> getmessages() async {
    final dataz = await Api.getdiscussion(id);
    if (dataz.isNotEmpty) {
      print(dataz);
      print(dataz['iduser']);
      socket.emit('joinchat', dataz['id']);

      setState(() {
        iduser = dataz['iduser'];
        _messages = dataz['messages'];
        name = dataz['profile']['fname'];
        prename = dataz['profile']['lname'];
        _id = dataz["id"];
        lenmsg = dataz['lenmsg'];
        photo = dataz['profile']['image'].length > 0
            ? dataz['profile']['image'][0]
            : "";
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
                radius: 30,
                backgroundImage: photo.isNotEmpty
                    ? Image.network(
                        '${Api.baseUrl}uploads/${photo.toString()}',
                        errorBuilder: (context, error, stackTrace) {
                          // Handle the error gracefully, e.g., by displaying a placeholder image.
                          return Image.asset(
                            'assets/angelina-jolie.jpg',
                          ); // Replace with your placeholder image asset.
                        },
                      ).image
                    : Image.asset(
                        'assets/angelina-jolie.jpg',
                      ).image),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 16)),
                Text(prename, style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {
              // Handle video call button press
            },
          ),
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {
              // Handle voice call button press
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (loadingmessages) ...[
            CircularProgressIndicator(),
          ],
          !isloading
              ? (Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return MessageBubble(
                        isMe: message['senderId'] != id,
                        text: message['messageText'] ?? '',
                        time: message['createdAt'] ?? '',
                      );
                    },
                  ),
                ))
              : Center(
                  child: CircularProgressIndicator(),
                ),
          /* This is to replace here  it here top Expanded
          Expanded(
  child: ListView.builder(
    itemCount: _messages.length,
    itemBuilder: (context, index) {
      final message = _messages[index];
      return Container(
        width: message['text'].length.toDouble() * 8.0, // Adjust the factor as needed
        child: MessageBubble(
          isMe: message['isMe'] ?? true,
          text: message['text'] ?? '',
          time: message['time'] ?? '',
        ),
      );
    },
  ),
),
 */
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(34),
              border: Border(
                top: BorderSide(color: Colors.black), // Add this line
                left: BorderSide(color: Colors.black),
                right: BorderSide(color: Colors.black),
                bottom: BorderSide(color: Colors.black),
              ),
            ),
            margin: EdgeInsets.all(8), // Add margin
            padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController, // Add this line
                    onSubmitted: _sendMessage, // Call _sendMessage on submit
                    decoration: InputDecoration.collapsed(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                /*  IconButton(
                  icon: Icon(Icons.image),
                  onPressed: () async {
                    final pickedFile = await ImagePicker()
                        .getImage(source: ImageSource.gallery);

                    if (pickedFile != null) {
                      final file = File(pickedFile.path);
                      await _sendImage('Image', file);
                    }
                  },
                ), */
                IconButton(
                  icon: Icon(Icons.keyboard_voice),
                  onPressed: () {
                    // Handle voice message recording
                  },
                ),
                InkWell(
                  onTap: () async {
                    if (_messageController.text.isNotEmpty) {
                      var messagedata = {
                        "senderId": senderIdController.text,
                        "receiverId": receiverIdController.text,
                        'messageText': _messageController.text,
                      };

                      // Call the API method to add the message text
                      await _sendMessage(_messageController.text);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(34),
                    ),
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatefulWidget {
  final bool isMe;
  final String text;
  final String time;

  MessageBubble({required this.isMe, required this.text, required this.time});
  @override
  _MessageScreenState createState() =>
      _MessageScreenState(isMe: isMe, text: text, time: time);
}

class _MessageScreenState extends State<MessageBubble> {
  final bool isMe;
  final String text;
  final String time;
  var open = false;
  _MessageScreenState(
      {required this.isMe, required this.text, required this.time});
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMe
                  ? Colors.purple.withOpacity(0.6)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
                onTap: () {
                  setState(() {
                    open = !open;
                  });
                },
                child: Column(
                  children: [
                    if (open) ...[
                      Text(
                        DateFormat('yyyy-MM-dd HH:mm')
                            .format(DateTime.parse(time)),
                        style: TextStyle(fontSize: 10),
                      ),
                      SizedBox(height: 4),
                    ],
                    Text(
                      text,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                )),
          )
        ]);
  }
}
