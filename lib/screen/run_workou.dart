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
int currentSet = 1;
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
    currentSet = 1;
    if (!checkLimits(currentExercise, exerciseLimit)) {
      currentExercise++;
    } else {
      if (!checkLimits(currentWorkout, workoutLimit)) {
        currentWorkout++;
        currentExercise = 0;
        currentSet = 1;
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    widget.workouts.length > 1
                        ? Container(
                            height: 350,
                            width: 40,
                            padding: const EdgeInsets.all(8.0),
                            child: StepProgressIndicator(
                              totalSteps: widget.workouts.length,
                              direction: Axis.vertical,
                              padding: 2,
                              currentStep: currentWorkout,
                              roundedEdges: Radius.circular(5),
                              selectedColor:
                                  Theme.of(context).colorScheme.primary,
                              unselectedColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                          )
                        : Container(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Center(
                          child: SizedBox(
                            height: 400,
                            width: double.infinity,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: ImageWidget(
                                    url: widget
                                        .workouts[currentWorkout].imageUrl)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    widget.workouts[currentWorkout].exercises[currentExercise]
                        ['name'],
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      showDragHandle: true,
                      useSafeArea: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.workouts[currentWorkout]
                                  .exercises[currentExercise]['description'],
                              style: Theme.of(context).textTheme.bodyLarge,

                              // overflow: TextOverflow.ellipsis,
                              // maxLines: 3,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
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
                ),
                SizedBox(
                  height: 10,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularStepProgressIndicator(
                      width: 100,
                      height: 100,
                      totalSteps: widget.workouts[currentWorkout]
                          .exercises[currentExercise]['sets'],
                      currentStep: currentSet,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      unselectedColor: Theme.of(context).colorScheme.secondary,
                      roundedCap: (p0, p1) => true,
                      // padding:3.75,
                    ),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "${widget.workouts[currentWorkout].exercises[currentExercise]['reps']}x \n reps",
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          // Text(
                          //   "reps",
                          //   style: Theme.of(context).textTheme.titleMedium,
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Text("Exercises left"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StepProgressIndicator(
                    totalSteps:
                        widget.workouts[currentWorkout].exercises.length,
                    padding: 2,
                    currentStep: currentExercise,
                    roundedEdges: Radius.circular(5),
                    selectedColor: Theme.of(context).colorScheme.primary,
                    unselectedColor: Theme.of(context).colorScheme.secondary,
                  ),
                )
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
                    child: CustomButton(
                        buttonText: currentSet !=
                                widget.workouts[currentWorkout]
                                    .exercises[currentExercise]['sets']
                            ? 'Next'
                            : "Done")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
