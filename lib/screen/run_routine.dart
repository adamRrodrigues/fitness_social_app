import 'package:firebase_auth/firebase_auth.dart';
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
  User? currentUser = FirebaseAuth.instance.currentUser;

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      WorkoutModel workoutModel =
          routine!.routines[widget.currentDay].workouts.removeAt(oldIndex);
      routine!.routines[widget.currentDay].workouts
          .insert(newIndex > oldIndex ? newIndex -= 1 : newIndex, workoutModel);
    });
  }

  @override
  void initState() {
    super.initState();
    routine = ref.read(routineProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Day ${widget.currentDay}"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: ReorderableListView.builder(
          itemCount: routine!.routines[widget.currentDay].workouts.length,
          onReorder: _onReorder,
          itemBuilder: (context, index) {
            return GestureDetector(
              key: ValueKey(index),
              child: WorkoutWidget(
                  workoutModel:
                      routine!.routines[widget.currentDay].workouts[index]),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        padding: const EdgeInsets.all(8),
        color: Colors.transparent,
        elevation: 0,
        child: Builder(builder: (context) {
          if (routine!.routines[widget.currentDay].workouts.isNotEmpty) {
            return GestureDetector(
                onTap: () {
                  context.pushNamed(RouteConstants.runWorkoutScreen,
                      extra: routine!.routines[widget.currentDay].workouts);
                },
                child: const CustomButton(buttonText: 'Start Your Workout'));
          } else {
            return GestureDetector(
                onTap: () {
                  context.pushNamed(RouteConstants.viewRoutinePage,
                      pathParameters: {
                        'id': currentUser!.uid
                      },
                      extra: {
                        'currentDay': widget.currentDay,
                        'startRoutine': false
                      });
                },
                child: const CustomButton(
                    buttonText: 'Get Some Workouts For Your Routine'));
          }
        }),
      ),
    );
  }
}
