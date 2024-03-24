import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubble(
      {super.key, required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    // var bubbleColor = Theme.of(context).colorScheme.primary;
    var bubbleColor = const Color.fromARGB(255, 52, 179, 71);
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser ? bubbleColor : Colors.grey.shade800,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 19),
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 15,
        ),
      ),
    );
  }
}
