import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final double? radius;

  const Avatar({super.key, this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.amber,
      radius: radius,
      child: Icon(
        Icons.person,
        size: radius,
      ),
    );
  }
}
