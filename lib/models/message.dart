class Message {
  final int? id;
  final String text;
  final String time;
  final bool isUserMessage;

  Message({
    this.id,
    required this.text,
    required this.time,
    required this.isUserMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'time': time,
      'isUserMessage': isUserMessage ? 1 : 0,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      text: map['text'],
      time: map['time'],
      isUserMessage: map['isUserMessage'] == 1,
    );
  }
}
