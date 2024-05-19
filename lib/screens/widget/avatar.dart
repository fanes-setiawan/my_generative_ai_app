import 'package:flutter/material.dart';
import 'package:my_generative_ai_app/constan/color.dart';

class Avatar extends StatelessWidget {
  final double? radius;

  const Avatar({super.key, this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: background,
      radius: radius,
      child: Icon(
        Icons.back_hand_rounded,
        size: radius,
        color: white,
      ),
    );
  }
}
