class Message {
  final String senderId;
  final String receiverId;
  final String messageText;
  final DateTime timestamp;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.messageText,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      messageText: json['messageText'] ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'messageText': messageText,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
