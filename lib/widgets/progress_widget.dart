import 'package:flutter/material.dart';

class ProgressWidget extends StatelessWidget {
  const ProgressWidget(
      {super.key,
      required this.value,
      this.maxValue = 3000,
      this.color = Colors.greenAccent});

  final double value;
  final double maxValue;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100,
        width: 100,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value.toInt().toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                value: value / maxValue,
                color: color,
                strokeCap: StrokeCap.round,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
