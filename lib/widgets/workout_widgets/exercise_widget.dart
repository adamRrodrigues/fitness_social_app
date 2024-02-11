import 'package:fitness_social_app/models/exercise_model.dart';
import 'package:flutter/material.dart';

class ExerciseWidget extends StatelessWidget {
  const ExerciseWidget({Key? key, required this.exerciseModel})
      : super(key: key);
  final ExerciseModel exerciseModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.primary), borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Icon(
            Icons.run_circle_outlined,
            size: 48,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(exerciseModel.name), SizedBox(width: 220, child: Text(exerciseModel.description, overflow: TextOverflow.ellipsis,))],
          ),
          Text('Sets: ${exerciseModel.sets.toString()}x')
        ]),
      ),
    );
  }
}
