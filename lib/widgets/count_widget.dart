import 'package:flutter/material.dart';

class CountWidget extends StatelessWidget {
  const CountWidget({super.key, required this.amount, required this.type});

  final String amount;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          amount,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          type,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
