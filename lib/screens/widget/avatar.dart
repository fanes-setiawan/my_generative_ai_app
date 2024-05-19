import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_generative_ai_app/constan/color.dart';

class Avatar extends StatelessWidget {
  final double? radius;

  const Avatar({super.key, this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: background,
      radius: radius,
      child: Container(
        margin: const EdgeInsets.all(2),
        child: SvgPicture.asset(
          'assets/robot.svg',
        ),
      ),
    );
  }
}
