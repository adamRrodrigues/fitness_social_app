import 'package:flutter/material.dart';

class BottomModalItem extends StatelessWidget {
  const BottomModalItem(
      {super.key,
      this.icon = Icons.camera_alt_outlined,
      this.iconRequired = false,
      required this.text});
  final IconData icon;
  final bool iconRequired;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: ListTile(title: Text(text))),
          iconRequired ? Icon(icon) : Container()
        ],
      ),
    );
  }
}
