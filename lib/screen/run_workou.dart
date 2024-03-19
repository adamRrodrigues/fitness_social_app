import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:fitness_social_app/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class RunWorkout extends ConsumerStatefulWidget {
  const RunWorkout({Key? key, required this.workouts}) : super(key: key);
  final List<WorkoutModel> workouts;

  @override
  _RunWorkoutState createState() => _RunWorkoutState();
}

int currentWorkout = 0;
int currentExercise = 0;
int currentSet = 0;
bool showDone = false;

bool checkLimits(int current, int limit) {
  if (current == limit) {
    return true;
  } else {
    return false;
  }
}

void incrementSet(int setLimit, int exerciseLimit, int workoutLimit) {
  //check workout limit
  if (checkLimits(currentSet, setLimit)) {
    currentSet = 0;
    if (!checkLimits(currentExercise, exerciseLimit)) {
      currentExercise++;
    } else {
      if (!checkLimits(currentWorkout, workoutLimit)) {
        currentWorkout++;
        currentExercise = 0;
        currentSet = 0;
      } else {
        showDone = true;
      }
    }
  } else {
    currentSet++;
  }
}

void reset() {
  // currentWorkout = 0;
  // currentExercise = 0;
  showDone = false;
  if (currentSet != 0) {
    currentSet--;
  } else {
    if (currentExercise != 0) {
      currentExercise--;
    } else {
      if (currentWorkout != 0) {
        currentWorkout--;
      }
    }
  }
}

class _RunWorkoutState extends ConsumerState<RunWorkout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workouts[currentWorkout].workoutName),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Builder(builder: (context) {
        if (!showDone) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 475,
                      width: 370,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ImageWidget(
                              url: widget.workouts[currentWorkout].imageUrl)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    widget.workouts[currentWorkout].exercises[currentExercise]
                        ['name'],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: Text(
                    widget.workouts[currentWorkout].exercises[currentExercise]
                        ['description'],
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    "sets",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StepProgressIndicator(
                    totalSteps: widget.workouts[currentWorkout]
                        .exercises[currentExercise]['sets'],
                    roundedEdges: Radius.circular(20),
                    currentStep: currentSet,
                    selectedColor: Theme.of(context).colorScheme.primary,
                    unselectedColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    "${widget.workouts[currentWorkout].exercises[currentExercise]['reps']}x",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: Text("Workout Completed"),
          );
        }
      }),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        padding: const EdgeInsets.all(8),
        color: Colors.transparent,
        elevation: 0,
        child: Row(
          children: [
            SizedBox(
              width: 60,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    reset();
                  });
                },
                icon: Icon(
                  Icons.restart_alt_rounded,
                  size: 30,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                    onTap: () {
                      if (showDone) {
                        context.pop();
                      } else {
                        setState(() {
                          incrementSet(
                              widget.workouts[currentWorkout]
                                  .exercises[currentExercise]['sets'],
                              widget.workouts[currentWorkout].exercises.length -
                                  1,
                              widget.workouts.length - 1);
                        });
                      }
                    },
                    child: const CustomButton(buttonText: 'Done')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
