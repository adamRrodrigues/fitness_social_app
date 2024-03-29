import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/commons/commons.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/services/drafts.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/utlis/utils.dart';
import 'package:fitness_social_app/widgets/bottom_modal_item_widget.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:fitness_social_app/widgets/pill_widget.dart';
import 'package:fitness_social_app/widgets/text_widget.dart';
import 'package:fitness_social_app/widgets/workout_widgets/local_exercise_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class CreateWorkoutPost extends ConsumerStatefulWidget {
  const CreateWorkoutPost({Key? key}) : super(key: key);

  @override
  _CreateWorkoutPostState createState() => _CreateWorkoutPostState();
}

class _CreateWorkoutPostState extends ConsumerState<CreateWorkoutPost> {
  TextEditingController titleController = TextEditingController();
  WorkoutDraft? workoutDraft;
  User? user;
  TextEditingController categoryController = TextEditingController();

  Uint8List? image;

  Utils? imagePicker;

  FocusNode focusNode = FocusNode();
  List<String> popularTags = [
    "Chest",
    "Arms",
    "Cardio",
    "Legs",
    "Back",
  ];

  void selectImage(String mode) async {
    try {
      Uint8List? file;
      if (mode == 'Camera') {
        file = await Utils().pickImage(ImageSource.camera);
      } else {
        file = await Utils().pickImage(ImageSource.gallery);
      }

      setState(() {
        image = file;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    imagePicker = ref.read(utilProvider);
    workoutDraft = ref.read(draftProvider);
    user = ref.read(userProvider);
    image = workoutDraft!.image;
    titleController.text = workoutDraft!.workoutName;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void delete(int index) {
      setState(() {
        workoutDraft!.categories.removeAt(index);
      });
    }

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          workoutDraft!.workoutName = titleController.text;
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              "Create a Workout",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            actions: [
              GestureDetector(
                onTap: () async {
                  if (titleController.text.isNotEmpty &&
                      image != null &&
                      workoutDraft!.exercises.isNotEmpty) {
                    WorkoutModel workoutModel = WorkoutModel(
                        workoutName: titleController.text,
                        categories: workoutDraft!.categories,
                        exercises: List.empty(),
                        uid: user!.uid,
                        isTemplate: false,
                        imageUrl: '',
                        postId: '',
                        createdAt: Timestamp.now(),
                        likeCount: 0,
                        likes: List.empty(),
                        templateId: '',
                        privacy: 'public');
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return const Center(child: CircularProgressIndicator());
                      },
                    );

                    try {
                      // await WorkoutPostServices()
                      //     .postTemplate(workoutModel, workoutDraft!.exercises);
                      await WorkoutPostServices().postWorkout(
                        workoutModel,
                        image!,
                        workoutDraft!.exercises,
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          Commons().snackBarMessage(e.toString(), Colors.red));
                    }
                    ref.invalidate(draftProvider);
                    if (context.mounted) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        Commons().snackBarMessage('not complete', Colors.red));
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.publish_rounded,
                    size: 28,
                  ),
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      showDragHandle: true,
                      useSafeArea: true,
                      builder: (context) {
                        return ListView(
                          shrinkWrap: true,
                          children: [
                            GestureDetector(
                              onTap: () => selectImage('Camera'),
                              child: const BottomModalItem(
                                  text: "Click a picture",
                                  icon: Icons.photo_outlined),
                            ),
                            const Divider(),
                            GestureDetector(
                              onTap: () => selectImage('Gallery'),
                              child: const BottomModalItem(
                                  text: "Choose from gallery",
                                  icon: Icons.camera_alt_outlined),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.secondary),
                          borderRadius: BorderRadius.circular(10)),
                      child: image == null
                          ? const Center(
                              child: Icon(size: 48, Icons.add_a_photo_outlined),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(
                                image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 35,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: workoutDraft!.categories.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: PillWidget(
                                    editable: true,
                                    delete: () {
                                      delete(index);
                                    },
                                    name: workoutDraft!.categories[index],
                                    active: false),
                              );
                            },
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        mini: true,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          focusNode.requestFocus();

                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            showDragHandle: true,
                            useSafeArea: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            builder: (context) {
                              return SizedBox(
                                height: 450,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomTextField(
                                              focusNode: focusNode,
                                              textController:
                                                  categoryController,
                                              hintText: 'add a category'),
                                        ),
                                        FloatingActionButton(
                                          mini: true,
                                          onPressed: () {
                                            setState(() {
                                              workoutDraft!.categories
                                                  .add(categoryController.text);
                                              categoryController.text = '';
                                            });
                                          },
                                          child: const Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    const Center(
                                      child: Text("Popular Tags: "),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: popularTags.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                workoutDraft!.categories
                                                    .add(popularTags[index]);
                                                context.pop();
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  title:
                                                      Text(popularTags[index]),
                                                ),
                                                const Divider()
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: const Icon(Icons.add),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CustomTextField(
                    maxLength: 20,
                      textController: titleController,
                      hintText: 'Give Your Workout a Name'),
                ),
                const SizedBox(
                  height: 10,
                ),
                workoutDraft!.exercises.isNotEmpty
                    ? ReorderableListView.builder(
                        onReorder: (oldIndex, newIndex) {
                          LocalExerciseModel exercise =
                              workoutDraft!.exercises.removeAt(oldIndex);
                          workoutDraft!.exercises.insert(
                              newIndex > oldIndex ? newIndex -= 1 : newIndex,
                              exercise);
                        },
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: workoutDraft!.exercises.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            key: ValueKey(index),
                            onTap: () {
                              context.pushNamed(RouteConstants.localEditWorkout,
                                  extra: {
                                    "editingExercise":
                                        workoutDraft!.exercises[index],
                                    "index": index
                                  });
                            },
                            child: Slidable(
                              
                              startActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      autoClose: true,
                                      borderRadius: BorderRadius.circular(10),
                                      flex: 1,
                                      onPressed: (context) {
                                        setState(() {
                                          workoutDraft!.exercises.add(
                                              workoutDraft!.exercises[index]);
                                        });
                                      },
                                      backgroundColor: Colors.greenAccent,
                                      foregroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      icon: Icons.replay_rounded,
                                      label: 'Duplicate',
                                    )
                                  ]),
                              endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      padding: const EdgeInsets.all(8),
                                      autoClose: true,
                                      borderRadius: BorderRadius.circular(10),
                                      flex: 1,
                                      onPressed: (context) {
                                        setState(() {
                                          workoutDraft!.exercises
                                              .removeAt(index);
                                        });
                                      },
                                      backgroundColor: Colors.redAccent,
                                      foregroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      icon: Icons.delete,
                                      label: 'Remove',
                                    )
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: LocalExerciseWidget(
                                    exerciseModel:
                                        workoutDraft!.exercises[index]),
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text('Any exercises you add will appear here'))
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
                  context.pushNamed(RouteConstants.createExercise,
                      extra: workoutDraft!.exercises);
                },
                child: const CustomButton(buttonText: 'Add Exercise')),
          ),
        ),
      ),
    );
  }
}
