import 'package:flutter/material.dart';

class PillWidget extends StatelessWidget {
  const PillWidget({Key? key, required this.name, required this.active})
      : super(key: key);

  final String name;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: active
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary),
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.background),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              name.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
