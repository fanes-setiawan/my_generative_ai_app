// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_generative_ai_app/constan/color.dart';
import 'package:my_generative_ai_app/constan/font.dart';
import 'package:my_generative_ai_app/screens/chat_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20.0,
            ),
            title(
              title: 'You AI Asistant',
              fontSize: 23,
              color: background,
            ),
            const SizedBox(
              height: 10.0,
            ),
            text(
              title:
                  'Using this software,you can ask you questions and receive articles using artificial intelligence assistant',
              fontSize: 12,
              color: black,
            ),
            Lottie.asset('assets/onboarding.json'),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: background,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  title(
                    title: "Continue",
                    color: white,
                    fontSize: 18,
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward,
                    size: 24.0,
                    color: white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
