import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/routine_model.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:fitness_social_app/widgets/workout_widgets/workout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RunRoutine extends ConsumerStatefulWidget {
  const RunRoutine({Key? key, required this.currentDay}) : super(key: key);
  final int currentDay;
  @override
  _RunRoutineState createState() => _RunRoutineState();
}

class _RunRoutineState extends ConsumerState<RunRoutine> {
  Routine? routine;

  @override
  void initState() {
    super.initState();
    routine = ref.read(routineProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: routine!.routines[widget.currentDay].workouts.length,
          itemBuilder: (context, index) {
            return WorkoutWidget(
                workoutModel:
                    routine!.routines[widget.currentDay].workouts[index]);
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        padding: const EdgeInsets.all(8),
        color: Colors.transparent,
        elevation: 0,
        child: GestureDetector(
            onTap: () {
              context.pushNamed(RouteConstants.runWorkoutScreen,
                  extra: routine!.routines[widget.currentDay].workouts);
            },
            child: const CustomButton(buttonText: 'Start Your Workout')),
      ),
    );
  }
}
