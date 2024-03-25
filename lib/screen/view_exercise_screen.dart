import 'package:fitness_social_app/models/exercise_model.dart';
import 'package:flutter/material.dart';

class ViewExerciseScreen extends StatelessWidget {
  const ViewExerciseScreen({Key? key, required this.exerciseModel})
      : super(key: key);
  final ExerciseModel exerciseModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text(exerciseModel.imageUrl),
          )
        ],
      ),
    );
  }
}
