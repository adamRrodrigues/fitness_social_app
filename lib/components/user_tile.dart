import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final String profileUrl;
  final void Function()? onTap;

  const UserTile(
      {super.key,
      required this.text,
      required this.profileUrl,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          // color: Theme.of(context).colorScheme.secondary,
          color: const Color.fromARGB(255, 32, 31, 31),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 0.5,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            // Icon
            // const Icon(Icons.person),
            CircleAvatar(
              radius: 25,
              foregroundImage: NetworkImage(profileUrl),
            ),

            const SizedBox(
              width: 20,
            ),

            // Text
            Text(text),
          ],
        ),
      ),
    );
  }
}
