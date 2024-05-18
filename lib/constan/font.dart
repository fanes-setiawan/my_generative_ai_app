import 'package:flutter/material.dart';

Widget text1({required String title, double? fontSize, Color? color}) {
  return Text(
    title,
    style: TextStyle(
      fontFamily: 'open sans',
      decoration: TextDecoration.none,
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.02,
    ),
  );
}

Widget title({required String title, double? fontSize, Color? color}) {
  return Text(
    title,
    style: TextStyle(
      fontFamily: 'open sans',
      decoration: TextDecoration.none,
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.02,
    ),
  );
}

Widget text({required String title, double? fontSize, Color? color}) {
  return Text(
    title,
    style: TextStyle(
      fontFamily: 'open sans',
      decoration: TextDecoration.none,
      color: color,
      fontSize: fontSize,
      letterSpacing: 1.02,
    ),
  );
}
