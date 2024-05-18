// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ai_bloc.dart';
import '../bloc/ai_event.dart';
import '../bloc/ai_state.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generative AI App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter prompt',
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final prompt = _controller.text;
                context.read<AiBloc>().add(GenerateContent(prompt));
              },
              child: Text('Generate Content'),
            ),
            SizedBox(height: 20),
            BlocBuilder<AiBloc, AiState>(
              builder: (context, state) {
                if (state is AiLoading) {
                  return CircularProgressIndicator();
                } else if (state is AiLoaded) {
                  return Text(state.content);
                } else if (state is AiError) {
                  return Text(state.message);
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
