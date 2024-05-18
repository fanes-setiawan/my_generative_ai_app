import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_generative_ai_app/bloc/ai_bloc.dart';
import 'package:my_generative_ai_app/constan/color.dart';
import 'package:my_generative_ai_app/models/message.dart';
import 'package:my_generative_ai_app/services/database_helper.dart';
import '../bloc/ai_event.dart';
import '../bloc/ai_state.dart';
import '../constan/font.dart';
import 'widget/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final messages = await DatabaseHelper.instance.getMessages();
    setState(() {
      _messages = messages.reversed.toList();
    });
  }

  void _addMessage(Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Icon(
          Icons.back_hand_rounded,
          size: 30.0,
          color: background,
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title(
              title: "Ai",
              color: background,
            ),
            text(
              title: "online",
              color: green,
              fontSize: 12,
            ),
          ],
        ),
        actions: const [],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatBubble(
                  direction:
                      message.isUserMessage ? Direction.right : Direction.left,
                  message: message.text,
                  photoUrl: null,
                  type: BubbleType.alone,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: null,
                              decoration: InputDecoration.collapsed(
                                filled: true,
                                fillColor: Colors.transparent,
                                hintText: "type here...",
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                ),
                                hoverColor: Colors.transparent,
                              ),
                              cursorColor: background,
                              controller: _controller,
                              onFieldSubmitted: (value) {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final messageText = _controller.text;
                    if (messageText.isNotEmpty) {
                      final userMessage =
                          Message(text: messageText, isUserMessage: true);
                      await DatabaseHelper.instance.insertMessage(userMessage);
                      _addMessage(userMessage);
                      context.read<AiBloc>().add(GenerateContent(messageText));
                      _controller.clear();
                    }
                  },
                  icon: Icon(
                    Icons.send_rounded,
                    size: 35.0,
                    color: background,
                  ),
                ),
              ],
            ),
          ),
          BlocListener<AiBloc, AiState>(
            listener: (context, state) async {
              if (state is AiLoaded) {
                final aiMessage = Message(
                  text: state.content,
                  isUserMessage: false,
                );
                await DatabaseHelper.instance.insertMessage(aiMessage);
                _addMessage(aiMessage);
              }
            },
            child: Container(),
          ),
        ],
      ),
    );
  }
}
