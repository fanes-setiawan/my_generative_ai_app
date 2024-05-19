// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
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
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController _controller = TextEditingController();
  List<Message> _messages = [];
  bool _isSpeaking = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  Future<void> _loadMessages() async {
    final messages = await DatabaseHelper.instance.getMessages();
    setState(() {
      _messages = messages.reversed.toList();
    });
  }

  Future<void> speak(String text) async {
    setState(() {
      _isSpeaking = true;
    });
    await flutterTts.setLanguage("id-ID");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  void _onPopupMenuSelected(String value, Message message) {
    switch (value) {
      case 'play':
        speak(message.text);
        break;
      case 'copy':
        Clipboard.setData(ClipboardData(text: message.text));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: grey.withOpacity(0.5),
            content: Text('Copied to clipboard'),
          ),
        );
        break;
      case 'delete':
        int? id = message.id;
        if (id != null) {
          setState(() {
            DatabaseHelper.instance.removeMessage(id);
            _messages.remove(message);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: grey.withOpacity(0.5),
              content: Text('Failed to delete message: ID is null'),
            ),
          );
        }
        break;
    }
  }

  String getFormattedTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time).inDays;

    if (difference == 0) {
      return DateFormat.Hm().format(time); // Just the time: HH:mm
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference > 1 && difference < 3) {
      return DateFormat('EEE').format(time); // Day of the week: Mon, Tue, etc.
    } else {
      return DateFormat('dd MMM').format(time); // Full date: 19 May
    }
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
        backgroundColor: background,
        elevation: 2,
        leading: Container(
          margin: EdgeInsets.all(10),
          child: SvgPicture.asset(
            'assets/robot.svg',
          ),
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title(
              title: "Gen-Ai",
              fontSize: 20,
              color: white,
            ),
            text(
              title: _isLoading ? "sedang mengetik . . ." : "online",
              color: grey,
              fontSize: 12,
            ),
          ],
        ),
        actions: [
          if (_isSpeaking == true)
            IconButton(
              onPressed: () {
                flutterTts.stop();
                setState(() {
                  _isSpeaking = false;
                });
              },
              icon: Icon(
                Icons.volume_up,
                color: white,
                size: 24.0,
              ),
            ),
          PopupMenuButton(
              iconColor: white,
              onSelected: (String result) {
                setState(() {
                  if (result == 'delete_all') {
                    DatabaseHelper.instance.deleteAllMessages();
                    _messages.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: grey.withOpacity(0.5),
                        content: const Text('Delete All Messages'),
                      ),
                    );
                  }
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem(
                      value: 'delete_all',
                      child: Text('Delete All Messages'),
                    )
                  ]),
        ],
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
                return GestureDetector(
                  onLongPress: () async {
                    final result = await showMenu(
                      context: context,
                      position: const RelativeRect.fromLTRB(100, 0, 0, 0),
                      items: const [
                        PopupMenuItem<String>(
                          value: 'play',
                          child: Text('Play'),
                        ),
                        PopupMenuItem<String>(
                          value: 'copy',
                          child: Text('Copy'),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    );

                    if (result != null) {
                      _onPopupMenuSelected(result, message);
                    }
                  },
                  child: ChatBubble(
                    direction: message.isUserMessage
                        ? Direction.right
                        : Direction.left,
                    message: message.text,
                    photoUrl: null,
                    type: BubbleType.alone,
                    time: getFormattedTime(DateTime.parse(message.time)),
                  ),
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
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                              minLines: 1,
                              decoration: InputDecoration.collapsed(
                                filled: true,
                                fillColor: Colors.transparent,
                                hintText: "Type a message...",
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
                      final userMessage = Message(
                          text: messageText,
                          isUserMessage: true,
                          time: DateTime.now().toString());

                      await DatabaseHelper.instance.insertMessage(userMessage);
                      _loadMessages();
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
              _isLoading = true;
              if (state is AiLoaded) {
                final aiMessage = Message(
                  text: state.content,
                  time: DateTime.now().toString(),
                  isUserMessage: false,
                );
                await DatabaseHelper.instance.insertMessage(aiMessage);
                _loadMessages();
                _addMessage(aiMessage);
                _isLoading = false;
              }
            },
            child: Container(),
          ),
        ],
      ),
    );
  }
}
