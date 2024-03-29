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
      vController!.dispose();
      video = await ImagePicker().pickVideo(
          source: ImageSource.gallery,
          maxDuration: const Duration(seconds: 10));
      finalVideo = File(video!.path);
      vController = VideoPlayerController.file(finalVideo!,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
        ..initialize().then((value) {
          setState(() {});
          vController!.setVolume(0);
          vController!.setLooping(true);
          vController!.play();
        });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    workoutDraft = ref.read(draftProvider);
    weightValue = widget.editingExercise.weight;
    repValue = widget.editingExercise.reps;
    setValue = widget.editingExercise.sets;
    nameController.text = widget.editingExercise.name;
    descriptionController.text = widget.editingExercise.description;
    totalTime = widget.editingExercise.time;
    selected = widget.editingExercise.type;
    hours = widget.editingExercise.time ~/ 60;
    minutes = widget.editingExercise.time % 60;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        vController!.dispose();
        return true;
      },
      child: Scaffold(
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
                  onLongPress: () => selectImage(),
                  child: SizedBox(
                    height: 400,
                    width: double.infinity,
                    child: Builder(builder: (context) {
                      if (finalVideo == null) {
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
                      } else {}
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
                  textController: nameController, hintText: 'exercise name'),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                  textController: descriptionController,
                  hintText: 'description'),
              const SizedBox(
                height: 10,
              ),
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
                        fillColor: MaterialStateProperty.all(Theme.of(context)
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
                        fillColor: MaterialStateProperty.all(Theme.of(context)
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
                height: 60,
              ),
              Builder(builder: (context) {
                if (selected == options[0]) {
                  return Column(
                    children: [
                      NumberPicker(
                        itemHeight: 50,
                        itemWidth: 50,
                        minValue: 0,
                        infiniteLoop: true,
                        itemCount: 2,
                        maxValue: 100,
                        value: weightValue.toInt(),
                        selectedTextStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 38),
                        onChanged: (value) {
                          setState(() {
                            weightValue = value.toDouble();
                          });
                        },
                      ),
                      Text('Weight: $weightValue' 'kgs'),
                      const SizedBox(
                        height: 40,
                      ),
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
                                      color:
                                          Theme.of(context).colorScheme.primary,
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
                                      color:
                                          Theme.of(context).colorScheme.primary,
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
                  return Column(
                    children: [
                      NumberPicker(
                        itemHeight: 50,
                        itemWidth: 50,
                        minValue: 0,
                        infiniteLoop: true,
                        itemCount: 2,
                        maxValue: 24,
                        value: hours.toInt(),
                        selectedTextStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 38),
                        onChanged: (value) {
                          setState(() {
                            hours = value;
                          });
                        },
                      ),
                      Text('Hours: $hours'),
                      const SizedBox(
                        height: 40,
                      ),
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
                                Text('Minutes: $minutes'),
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
                                Text('Seconds: $seconds'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
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
                    } else {
                      ExerciseModel exerciseModel = ExerciseModel(
                          name: nameController.text,
                          type: selected,
                          description: descriptionController.text,
                          weight: weightValue,
                          reps: repValue,
                          sets: setValue);
                      workoutDraft!.fetchedExercises.removeAt(widget.index);
                      workoutDraft!.fetchedExercises
                          .insert(widget.index, exerciseModel);
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
                        workoutDraft!.fetchedExercises.removeAt(widget.index);
                        workoutDraft!.fetchedExercises
                            .insert(widget.index, editedExercise);
                      } else {
                        ExerciseModel exerciseModel = ExerciseModel(
                          type: selected,
                          name: nameController.text,
                          description: descriptionController.text,
                          time: totalTime,
                        );
                        workoutDraft!.fetchedExercises.removeAt(widget.index);
                        workoutDraft!.fetchedExercises
                            .insert(widget.index, exerciseModel);
                      }
                    }
                  }
                  context.pop();
                  try {
                    vController!.dispose();
                  } catch (e) {}
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(Commons()
                      .snackBarMessage(
                          'Exercise must have a name', Colors.red));
                }
              },
              child: const CustomButton(buttonText: 'Done')),
        ),
      ),
    );
  }
}
