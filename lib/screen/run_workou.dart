import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/services/shared_preferences.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:fitness_social_app/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:video_player/video_player.dart';

class RunWorkout extends ConsumerStatefulWidget {
  const RunWorkout({Key? key, required this.workouts}) : super(key: key);
  final List<WorkoutModel> workouts;

  @override
  _RunWorkoutState createState() => _RunWorkoutState();
}

ValueNotifier<int> currentWorkout = ValueNotifier(0);
ValueNotifier<int> currentExercise = ValueNotifier(0);
ValueNotifier<int> currentSet = ValueNotifier(1);
ValueNotifier<bool> showDone = ValueNotifier(false);
ValueNotifier<int> currentSeconds = ValueNotifier(0);
int workoutSeconds = 100;
VideoPlayerController? vController;
Day? day;
User? user;

bool checkLimits(int current, int limit) {
  if (current == limit) {
    return true;
  } else {
    return false;
  }
}

void incrementSet(int setLimit, int exerciseLimit, int workoutLimit) async {
  //check workout limit

  if (checkLimits(currentSet.value, setLimit)) {
    currentSet.value = 1;
    if (!checkLimits(currentExercise.value, exerciseLimit)) {
      currentExercise.value++;
    } else {
      if (!checkLimits(currentWorkout.value, workoutLimit)) {
        currentWorkout.value++;
        currentExercise.value = 0;
        currentSet.value = 1;
      } else {
        endWorkout();

        currentExercise.value = 0;
        currentWorkout.value = 0;
        currentSeconds.value = 0;
        currentSet.value = 1;
      }
    }
  } else {
    currentSet.value++;
  }
}

void endWorkout() async {
  showDone.value = true;
  if (await day!.checkDay()) {
    await FirebaseFirestore.instance
        .collection('user_stats')
        .doc(user!.uid)
        .update({"workoutStreak": FieldValue.increment(1)});
    day!.setDay();
  }
}

void reset() {
  if (showDone.value) {
    showDone.value = false;

    resetState();
  } else {
    if (currentSet.value != 0) {
      currentSet.value--;
    } else {
      if (currentExercise.value != 0) {
        currentExercise.value--;
      } else {
        if (currentWorkout.value != 0) {
          currentWorkout.value--;
        }
      }
    }
  }
  currentSeconds.value = 0;
}

void resetState() {
  currentWorkout.value = 0;
  currentExercise.value = 0;
  currentSet.value = 1;
  currentSeconds.value = 0;
}

class _RunWorkoutState extends ConsumerState<RunWorkout> {
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    int totalTime = widget.workouts[currentWorkout.value]
        .exercises[currentExercise.value]["time"];
    currentSeconds.value = totalTime > 0 ? (totalTime * 60) : 500;
    workoutSeconds = totalTime > 0 ? (totalTime * 60) : 500;

    Timer.periodic(
      oneSec,
      (Timer timer) {
        if (currentSeconds.value == 0) {
          // setState(() {
          timer.cancel();
          // });
        } else {
          // setState(() {
          currentSeconds.value--;
          // });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    day = ref.read(dayProvider);
    user = ref.read(userProvider);
  }

  @override
  void dispose() {
    super.dispose();
    try {
      vController!.dispose();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.workouts[currentWorkout.value].workoutName),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: ValueListenableBuilder(
            valueListenable: showDone,
            builder: (context, showDone, child) {
              if (!showDone) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      widget.workouts.length > 1
                          ? Container(
                              height: 55,
                              // width: 60,
                              padding: const EdgeInsets.all(16.0),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: widget.workouts.length,
                                itemBuilder: (context, index) {
                                  return ValueListenableBuilder(
                                      valueListenable: currentWorkout,
                                      builder:
                                          (context, currentWorkout, child) {
                                        return TimelineTile(
                                          // alignment: TimelineAlign.center,
                                          axis: TimelineAxis.horizontal,
                                          isFirst: index == 0 ? true : false,
                                          isLast: widget.workouts.length ==
                                                  index + 1
                                              ? true
                                              : false,
                                          beforeLineStyle: LineStyle(
                                              color: currentWorkout >= index
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                          indicatorStyle: IndicatorStyle(
                                              width: 20,
                                              height: 20,
                                              color: currentWorkout >= index
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                          afterLineStyle: LineStyle(
                                              color: currentWorkout >= index
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                        );
                                      });
                                },
                              ),
                            )
                          : Container(),
                      Center(
                        child: ValueListenableBuilder(
                            valueListenable: currentWorkout,
                            builder: (context, currentWorkout, c) {
                              return SizedBox(
                                height: 350,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: ValueListenableBuilder(
                                        valueListenable: currentExercise,
                                        builder:
                                            (context, currentExercise, child) {
                                          if (widget.workouts[currentWorkout]
                                                          .exercises[
                                                      currentExercise]
                                                  ['imageUrl'] !=
                                              "") {
                                            try {
                                              Uri uri = Uri.parse(widget
                                                      .workouts[currentWorkout]
                                                      .exercises[
                                                  currentExercise]['imageUrl']);
                                              vController = VideoPlayerController
                                                  .contentUri(uri,
                                                      videoPlayerOptions:
                                                          VideoPlayerOptions(
                                                              mixWithOthers:
                                                                  true))
                                                ..initialize().then((value) {
                                                  try {
                                                    vController!.setVolume(0);
                                                    vController!
                                                        .setLooping(true);
                                                    vController!.play();
                                                  } catch (e) {}
                                                });
                                              return Builder(
                                                builder: (context) {
                                                  if (!vController!
                                                      .value.isInitialized) {
                                                    return Stack(
                                                      fit: StackFit.passthrough,
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                        AspectRatio(
                                                          aspectRatio: 0.65,
                                                          child: VideoPlayer(
                                                              vController!),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                },
                                              );
                                            } catch (e) {
                                              print(e);
                                              return Container();
                                            }
                                          } else {
                                            return ImageWidget(
                                                url: widget
                                                    .workouts[currentWorkout]
                                                    .imageUrl);
                                          }
                                        })),
                              );
                            }),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ValueListenableBuilder(
                          valueListenable: currentWorkout,
                          builder: (context, currentWorkout, c) {
                            return ValueListenableBuilder(
                                valueListenable: currentExercise,
                                builder: (context, currentExercise, child) {
                                  return Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          widget.workouts[currentWorkout]
                                                  .exercises[currentExercise]
                                              ['name'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              showDragHandle: true,
                                              useSafeArea: true,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      20))),
                                              builder: (context) {
                                                return Container(
                                                  constraints:
                                                      const BoxConstraints(
                                                          minHeight: 200),
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      widget
                                                                  .workouts[
                                                                      currentWorkout]
                                                                  .exercises[
                                                              currentExercise]
                                                          ['description'],
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge,

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
                                              widget.workouts[currentWorkout]
                                                          .exercises[
                                                      currentExercise]
                                                  ['description'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              "Weight: ${widget.workouts[currentWorkout].exercises[currentExercise]['weight'].toString()} kgs"),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      ValueListenableBuilder(
                          valueListenable: currentWorkout,
                          builder: (context, currentWorkout, c) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ValueListenableBuilder(
                                    valueListenable: currentExercise,
                                    builder: (context, currentExercise, child) {
                                      if (widget.workouts[currentWorkout]
                                                  .exercises[currentExercise]
                                              ["type"] ==
                                          "sets") {
                                        return Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            ValueListenableBuilder(
                                                valueListenable: currentSet,
                                                builder: (context, currentSet,
                                                    child) {
                                                  return CircularStepProgressIndicator(
                                                    width: 100,
                                                    height: 100,
                                                    totalSteps: widget
                                                                        .workouts[
                                                                            currentWorkout]
                                                                        .exercises[
                                                                    currentExercise]
                                                                ['sets'] ==
                                                            0
                                                        ? 1
                                                        : widget
                                                                    .workouts[
                                                                        currentWorkout]
                                                                    .exercises[
                                                                currentExercise]
                                                            ['sets'],
                                                    currentStep: currentSet,
                                                    selectedColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                    unselectedColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                    roundedCap: (p0, p1) =>
                                                        true,
                                                    // padding:3.75,
                                                  );
                                                }),
                                            Center(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "${widget.workouts[currentWorkout].exercises[currentExercise]['reps']}x \n reps",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
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
                                        );
                                      } else {
                                        return ValueListenableBuilder(
                                            valueListenable: currentSeconds,
                                            builder: (context, currentSeconds,
                                                child) {
                                              return Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 100,
                                                    width: 100,
                                                    child:
                                                        CircularProgressIndicator(
                                                      value: currentSeconds /
                                                          workoutSeconds,
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .secondary,
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          currentSeconds
                                                              .toString(),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        // Text(
                                                        //   "reps",
                                                        //   style: Theme.of(context).textTheme.titleMedium,
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            });
                                      }
                                    }),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ValueListenableBuilder(
                                        valueListenable: currentExercise,
                                        builder:
                                            (context, currentExercise, child) {
                                          return CircularStepProgressIndicator(
                                            width: 100,
                                            height: 100,
                                            totalSteps: widget
                                                .workouts[currentWorkout]
                                                .exercises
                                                .length,

                                            currentStep: currentExercise,
                                            selectedColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            unselectedColor: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            roundedCap: (p0, p1) => true,
                                            // padding:3.75,
                                          ).animate().rotate();
                                        }),
                                    Center(
                                      child: Text(
                                        "Exercises\n left",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text("Workout Completed"),
                );
              }
            }),
        bottomNavigationBar: BottomAppBar(
          height: 60,
          padding: const EdgeInsets.all(8),
          color: Colors.transparent,
          elevation: 0,
          child: ValueListenableBuilder(
              valueListenable: showDone,
              builder: (context, showDone, c) {
                if (!showDone) {
                  return Row(
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: GestureDetector(
                              onTap: () async {
                                if (widget.workouts[currentWorkout.value]
                                            .exercises[currentExercise.value]
                                        ['type'] ==
                                    "sets") {
                                  incrementSet(
                                      widget.workouts[currentWorkout.value]
                                              .exercises[currentExercise.value]
                                          ['sets'],
                                      widget.workouts[currentWorkout.value]
                                              .exercises.length -
                                          1,
                                      widget.workouts.length - 1);
                                } else {
                                  if (currentSeconds.value == 0) {
                                    startTimer();
                                  } else {
                                    workoutSeconds = 100;
                                    currentSeconds.value = 0;

                                    if (!checkLimits(
                                        currentExercise.value,
                                        widget.workouts[currentWorkout.value]
                                                .exercises.length -
                                            1)) {
                                      currentExercise.value++;
                                      print("1");
                                    } else {
                                      if (!checkLimits(currentWorkout.value,
                                          widget.workouts.length - 1)) {
                                        currentWorkout.value++;
                                        currentExercise.value = 0;
                                        currentSet.value = 1;
                                      } else {
                                        // if (await day!.checkDay()) {
                                        endWorkout();
                                        // }
                                      }
                                    }
                                  }
                                }
                              },
                              child: ValueListenableBuilder(
                                  valueListenable: currentSeconds,
                                  builder: (context, currentSeconds, child) {
                                    if (widget.workouts[currentWorkout.value]
                                                .exercises[
                                            currentExercise.value]['type'] ==
                                        "time") {
                                      return CustomButton(
                                          buttonText: currentSeconds == 0
                                              ? "Start"
                                              : "Skip");
                                    } else {
                                      return const CustomButton(
                                          buttonText: "Next");
                                    }
                                  }),
                            )),
                      ),
                    ],
                  );
                } else {
                  return Row(
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
                        child: GestureDetector(
                          onTap: () {
                            resetState();
                            showDone = true;
                            context.pop();
                          },
                          child: CustomButton(
                            buttonText: "Done",
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }
}
