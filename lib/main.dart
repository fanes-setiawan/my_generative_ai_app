// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_generative_ai_app/screens/splash_screen.dart';
import 'package:my_generative_ai_app/screens/chat_screen.dart';
import 'bloc/ai_bloc.dart';
import 'repositories/ai_repository.dart';

void main() {
  final aiRepository =
      AiRepository(apiKey: 'AIzaSyDF2pXM8z0abrDeFSEAW8S0MQi1cV6rO0c');

  runApp(MyApp(aiRepository: aiRepository));
}

class MyApp extends StatelessWidget {
  final AiRepository aiRepository;

  MyApp({required this.aiRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AiBloc(aiRepository: aiRepository),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Generative AI App',
        home: const SplashScreen(),
        routes: {
          '/chat': (context) => const ChatScreen(),
          // Other routes can be defined here
        },
      ),
    );
  }
}
