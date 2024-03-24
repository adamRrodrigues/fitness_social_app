import 'package:fitness_social_app/models/exercise_model.dart';
import 'package:flutter/material.dart';

class ExerciseWidget extends StatelessWidget {
  const ExerciseWidget({Key? key, required this.exerciseModel})
      : super(key: key);
  final ExerciseModel exerciseModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                exerciseModel.type == "time"
                    ? Icons.run_circle_outlined
                    : Icons.line_weight,
                size: 48,
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exerciseModel.name),
                  SizedBox(
                      width: 220,
                      child: Text(
                    exerciseModel.description,
                    overflow: TextOverflow.ellipsis,
                  ))
                ],
              ),
            ],
          ),
          exerciseModel.type == 'sets'
              ? Text('Sets: ${exerciseModel.sets.toString()}x')
              : Text('Time: ${exerciseModel.time.toString()} min')
        ]),
      ),
    );
  }
}
