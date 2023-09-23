import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key, required this.buttonText}) : super(key: key);

  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Theme.of(context).colorScheme.primary, width: 2)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            buttonText,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}
