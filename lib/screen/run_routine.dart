import 'package:fitness_social_app/models/routine_model.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/widgets/workout_widgets/workout_widget.dart';
import 'package:flutter/material.dart';

class RunRoutine extends StatefulWidget {
  const RunRoutine({Key? key, required this.routine, required this.day}) : super(key: key);
  final List<WorkoutModel> routine;
  final int day;
  @override
  _RunRoutineState createState() => _RunRoutineState();
}

class _RunRoutineState extends State<RunRoutine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [WorkoutWidget(workoutModel: widget.routine[widget.day])],
        ),
      ),
    );
  }
}
