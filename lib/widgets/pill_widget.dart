import 'package:flutter/material.dart';

class PillWidget extends StatelessWidget {
  const PillWidget(
      {Key? key,
      required this.name,
      required this.active,
      required this.editable,
      required this.delete})
      : super(key: key);

  final String name;
  final bool active;
  final bool editable;
  final VoidCallback delete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: active
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary),
          borderRadius: BorderRadius.circular(10),
          color: active
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.background),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text(
                name.toUpperCase(),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: active
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondary),
                // textAlign: TextAlign.center,
              ),
            ),
            editable
                ? GestureDetector(
                    onTap: () {
                      delete();
                    },
                    child: Center(
                        child: Text(
                      '  X',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    )),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
