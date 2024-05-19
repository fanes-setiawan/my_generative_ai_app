import 'package:flutter/material.dart';
import 'package:my_generative_ai_app/constan/color.dart';
import 'package:my_generative_ai_app/constan/font.dart';

import 'avatar.dart';

enum BubbleType {
  top,
  middle,
  bottom,
  alone,
}

enum Direction {
  left,
  right,
}

class ChatBubble extends StatelessWidget {
  final Direction direction;
  final String message;
  final String? photoUrl;
  final String time;
  final BubbleType type;

  const ChatBubble(
      {super.key,
      required this.direction,
      required this.message,
      this.photoUrl,
      required this.time,
      required this.type});

  @override
  Widget build(BuildContext context) {
    final isOnLeft = direction == Direction.left;

    return Row(
      mainAxisAlignment:
          isOnLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        if (isOnLeft) _buildLeading(type),
        SizedBox(width: isOnLeft ? 4 : 0),
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            borderRadius: _borderRadius(direction, type),
            color: isOnLeft ? Colors.grey[200] : background,
          ),
          child: Column(
            crossAxisAlignment:
                isOnLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Text(
                message,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: isOnLeft ? Colors.black : Colors.white,
                ),
              ),
              title(title: time, fontSize: 9, color: black.withOpacity(0.5)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeading(BubbleType type) {
    if (type == BubbleType.alone || type == BubbleType.bottom) {
      return const Avatar(
        radius: 12,
      );
    }
    return const SizedBox(
      width: 24,
    );
  }

  BorderRadius _borderRadius(Direction dir, BubbleType type) {
    const radius1 = Radius.circular(15);
    const radius2 = Radius.circular(5);
    switch (type) {
      case BubbleType.top:
        return dir == Direction.left
            ? const BorderRadius.only(
                topLeft: radius1,
                topRight: radius1,
                bottomLeft: radius2,
                bottomRight: radius1,
              )
            : const BorderRadius.only(
                topLeft: radius1,
                topRight: radius1,
                bottomLeft: radius1,
                bottomRight: radius2,
              );

      case BubbleType.middle:
        return dir == Direction.left
            ? const BorderRadius.only(
                topLeft: radius2,
                topRight: radius1,
                bottomLeft: radius2,
                bottomRight: radius1,
              )
            : const BorderRadius.only(
                topLeft: radius1,
                topRight: radius2,
                bottomLeft: radius1,
                bottomRight: radius2,
              );
      case BubbleType.bottom:
        return dir == Direction.left
            ? const BorderRadius.only(
                topLeft: radius2,
                topRight: radius1,
                bottomLeft: radius1,
                bottomRight: radius1,
              )
            : const BorderRadius.only(
                topLeft: radius1,
                topRight: radius2,
                bottomLeft: radius1,
                bottomRight: radius1,
              );
      case BubbleType.alone:
        return BorderRadius.circular(15);
    }
  }
}
