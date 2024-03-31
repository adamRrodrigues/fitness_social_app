import 'dart:io';

import 'package:fitness_social_app/commons/commons.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/exercise_model.dart';
import 'package:fitness_social_app/services/drafts.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:fitness_social_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:video_player/video_player.dart';

class EditExercise extends ConsumerStatefulWidget {
  const EditExercise(
      {Key? key, required this.editingExercise, required this.index})
      : super(key: key);
  final ExerciseModel editingExercise;
  final int index;

  @override
  _EditExerciseState createState() => _EditExerciseState();
}

class _EditExerciseState extends ConsumerState<EditExercise> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  double weightValue = 0;
  int decimalValue = 0;
  int nominalValue = 0;
  int repValue = 0;
  int setValue = 0;
  WorkoutDraft? workoutDraft;

  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  int totalTime = 0;
  List<String> options = ["sets", "time"];
  String selected = "sets";

  void calculateTime() {
    totalTime = ((hours * 60) + minutes + (seconds / 60)).toInt();
  }

  VideoPlayerController? vController;
  XFile? video;
  File? finalVideo;
  void selectImage() async {
    try {
      video = await ImagePicker().pickVideo(
          source: ImageSource.gallery,
          maxDuration: const Duration(seconds: 10));
      finalVideo = File(video!.path);
      vController = VideoPlayerController.file(finalVideo!,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
        ..initialize().then((value) {
          if (vController!.value.duration.inSeconds > 20) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  "Video Duration cannot be more than 20 seconds",
                  style: TextStyle(color: Colors.white),
                )));
            finalVideo = null;
          } else {
            setState(() {});
            vController!.setVolume(0);
            vController!.setLooping(true);
            vController!.play();
          }
        });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    workoutDraft = ref.read(draftProvider);
    nameController.text = widget.editingExercise.name;
    descriptionController.text = widget.editingExercise.description;
    weightValue = widget.editingExercise.weight;
    int intpart = weightValue.toInt();
    double decpart = weightValue - intpart;
    nominalValue = intpart;
    decimalValue = (decpart * 10).toInt();
    repValue = widget.editingExercise.reps;
    setValue = widget.editingExercise.sets;
    totalTime = widget.editingExercise.time;
    selected = widget.editingExercise.type;
    hours = widget.editingExercise.time ~/ 60;
    minutes = widget.editingExercise.time % 60;
    print(widget.editingExercise);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('edit exercise'),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () => selectImage(),
                child: SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: Builder(builder: (context) {
                    if (finalVideo == null) {
                      if (widget.editingExercise.imageUrl != "") {
                        try {
                          vController = VideoPlayerController.contentUri(
                              Uri.parse(widget.editingExercise.imageUrl),
                              videoPlayerOptions:
                                  VideoPlayerOptions(mixWithOthers: true))
                            ..initialize().then((value) {
                              vController!.setVolume(0);
                              vController!.setLooping(true);
                              vController!.play();
                            });
                        } catch (e) {
                          print(e);
                        }
                      } else {
                        return Center(
                          child: Icon(
                            Icons.play_circle_outline_outlined,
                            size: 42,
                          ),
                        );
                      }
                    }
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                        AspectRatio(
                            aspectRatio: 0.65,
                            child: VideoPlayer(vController!)),
                      ],
                    );
                  }),
                ),
              ),
            ),
            CustomTextField(
                maxLength: 30,
                textController: nameController,
                hintText: 'exercise name'),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
                maxLength: 250,
                textController: descriptionController,
                hintText: 'description'),
            const SizedBox(
              height: 10,
            ),
            StatefulBuilder(builder: (context, setState) {
              return Column(
                children: [
                  Row(
                    // shrinkWrap: true,
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(options[0]),
                          leading: Radio<String>(
                            value: options[0],
                            groupValue: selected,
                            activeColor: Theme.of(context)
                                .colorScheme
                                .primary, // Change the active radio button color here
                            fillColor: MaterialStateProperty.all(Theme.of(
                                    context)
                                .colorScheme
                                .primary), // Change the fill color when selected
                            splashRadius:
                                20, // Change the splash radius when clicked
                            onChanged: (String? value) {
                              setState(() {
                                selected = value.toString();
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(options[1]),
                          leading: Radio<String>(
                            value: options[1],
                            groupValue: selected,
                            activeColor: Theme.of(context)
                                .colorScheme
                                .primary, // Change the active radio button color here
                            fillColor: MaterialStateProperty.all(
                                Theme.of(context)
                                    .colorScheme
                                    .primary), //ll color when selected
                            splashRadius:
                                20, // Change the splash radius when clicked
                            onChanged: (String? value) {
                              setState(() {
                                selected = value.toString();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Builder(builder: (context) {
                        return NumberPicker(
                          itemHeight: 50,
                          itemWidth: 60,
                          minValue: 0,
                          infiniteLoop: true,
                          itemCount: 3,
                          maxValue: 99,
                          value: nominalValue.toInt(),
                          selectedTextStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 38),
                          onChanged: (value) {
                            setState(() {
                              nominalValue = value;
                              weightValue = nominalValue + decimalValue / 10;
                            });
                          },
                        );
                      }),
                      const Text(
                        ".",
                        style: TextStyle(fontSize: 32),
                      ),
                      NumberPicker(
                        itemHeight: 50,
                        itemWidth: 60,
                        minValue: 0,
                        infiniteLoop: true,
                        itemCount: 3,
                        maxValue: 9,
                        value: decimalValue.toInt(),
                        selectedTextStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 38),
                        onChanged: (value) {
                          setState(() {
                            decimalValue = value;
                            weightValue = nominalValue + decimalValue / 10;
                          });
                        },
                      ),
                    ],
                  ),
                  Text('Weight: $weightValue' 'kgs'),
                  Builder(builder: (context) {
                    if (selected == options[0]) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    NumberPicker(
                                      itemHeight: 50,
                                      itemWidth: 50,
                                      minValue: 0,
                                      infiniteLoop: true,
                                      itemCount: 2,
                                      maxValue: 25,
                                      selectedTextStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 38),
                                      value: repValue,
                                      onChanged: (value) {
                                        setState(() {
                                          repValue = value;
                                        });
                                      },
                                    ),
                                    Text('Reps: $repValue'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    NumberPicker(
                                      itemHeight: 50,
                                      itemWidth: 50,
                                      minValue: 0,
                                      infiniteLoop: true,
                                      itemCount: 2,
                                      maxValue: 8,
                                      selectedTextStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 38),
                                      value: setValue,
                                      onChanged: (value) {
                                        setState(() {
                                          setValue = value;
                                        });
                                      },
                                    ),
                                    Text('Sets: $setValue'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                NumberPicker(
                                  itemHeight: 50,
                                  itemWidth: 50,
                                  minValue: 0,
                                  infiniteLoop: true,
                                  itemCount: 2,
                                  maxValue: 5,
                                  value: hours.toInt(),
                                  selectedTextStyle: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 38),
                                  onChanged: (value) {
                                    setState(() {
                                      hours = value;
                                    });
                                  },
                                ),
                                Text('Hrs: $hours'),
                              ],
                            ),
                            const Text(
                              ":",
                              style: TextStyle(fontSize: 32),
                            ),
                            Column(
                              children: [
                                NumberPicker(
                                  itemHeight: 50,
                                  itemWidth: 50,
                                  minValue: 0,
                                  infiniteLoop: true,
                                  itemCount: 2,
                                  maxValue: 60,
                                  selectedTextStyle: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 38),
                                  value: minutes,
                                  onChanged: (value) {
                                    setState(() {
                                      minutes = value;
                                    });
                                  },
                                ),
                                Text('Min: $minutes'),
                              ],
                            ),
                            const Text(
                              ":",
                              style: TextStyle(fontSize: 32),
                            ),
                            Column(
                              children: [
                                NumberPicker(
                                  itemHeight: 50,
                                  itemWidth: 50,
                                  minValue: 0,
                                  infiniteLoop: true,
                                  itemCount: 2,
                                  maxValue: 60,
                                  selectedTextStyle: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 38),
                                  value: seconds,
                                  onChanged: (value) {
                                    setState(() {
                                      seconds = value;
                                    });
                                  },
                                ),
                                Text('Sec: $seconds'),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                  }),
                ],
              );
            }),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        padding: const EdgeInsets.all(8),
        color: Colors.transparent,
        elevation: 0,
        child: GestureDetector(
            onTap: () {
              if (nameController.text.isNotEmpty) {
                if (selected == options[0]) {
                  if (repValue != 0 && setValue != 0) {
                    if (finalVideo != null) {
                      LocalExerciseModel editedExercise = LocalExerciseModel(
                          description: descriptionController.text,
                          toolName: "",
                          weight: weightValue,
                          reps: repValue,
                          sets: setValue,
                          time: totalTime,
                          type: selected,
                          name: nameController.text);
                      editedExercise.video = finalVideo;
                      workoutDraft!.fetchedExercises.removeAt(widget.index);
                      workoutDraft!.fetchedExercises
                          .insert(widget.index, editedExercise);
                      context.pop();
                    } else {
                      ExerciseModel exerciseModel = ExerciseModel(
                          name: nameController.text,
                          type: selected,
                          description: descriptionController.text,
                          imageUrl: widget.editingExercise.imageUrl,
                          weight: weightValue,
                          reps: repValue,
                          sets: setValue);
                      workoutDraft!.fetchedExercises.removeAt(widget.index);
                      workoutDraft!.fetchedExercises
                          .insert(widget.index, exerciseModel);
                      context.pop();
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(Commons()
                        .snackBarMessage(
                            'Both Sets and Reps Should Be More Than 0',
                            Colors.red));
                  }
                } else {
                  calculateTime();
                  if (totalTime == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(Commons()
                        .snackBarMessage('Time cannot be 0', Colors.red));
                  } else {
                    if (finalVideo != null) {
                      LocalExerciseModel editedExercise = LocalExerciseModel(
                          description: descriptionController.text,
                          toolName: "",
                          weight: weightValue,
                          reps: repValue,
                          sets: setValue,
                          time: totalTime,
                          type: selected,
                          name: nameController.text);
                      editedExercise.video = finalVideo;
                      workoutDraft!.fetchedExercises[widget.index] =
                          editedExercise;
                      context.pop();
                    } else {
                      ExerciseModel exerciseModel = ExerciseModel(
                        type: selected,
                        name: nameController.text,
                        imageUrl: widget.editingExercise.imageUrl,
                        description: descriptionController.text,
                        time: totalTime,
                      );
                      workoutDraft!.fetchedExercises[widget.index] =
                          exerciseModel;
                      context.pop();
                    }
                  }
                }
                try {} catch (e) {}
              } else {
                ScaffoldMessenger.of(context).showSnackBar(Commons()
                    .snackBarMessage('Exercise must have a name', Colors.red));
              }
            },
            child: const CustomButton(buttonText: 'Done')),
      ),
    );
  }
}
