import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/commons/commons.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/exercise_model.dart';
import 'package:fitness_social_app/models/routine_model.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/services/drafts.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/services/routine_services.dart';
import 'package:fitness_social_app/utlis/utils.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:fitness_social_app/widgets/image_widget.dart';
import 'package:fitness_social_app/widgets/pill_widget.dart';
import 'package:fitness_social_app/widgets/text_widget.dart';
import 'package:fitness_social_app/widgets/workout_widgets/exercise_widget.dart';
import 'package:fitness_social_app/widgets/workout_widgets/local_exercise_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modals/modals.dart';

class EditWorkout extends ConsumerStatefulWidget {
  const EditWorkout({Key? key, required this.workoutModel, required this.day})
      : super(key: key);
  final WorkoutModel workoutModel;
  final int day;
  @override
  _EditWorkoutState createState() => _EditWorkoutState();
}

class _EditWorkoutState extends ConsumerState<EditWorkout> {
  TextEditingController titleController = TextEditingController();
  WorkoutDraft? workoutDraft;
  User? user;
  Routine? routine;
  TextEditingController categoryController = TextEditingController();

  Uint8List? image;

  Utils? imagePicker;

  FocusNode focusNode = FocusNode();

  bool loadingExercises = true;

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
    routine = ref.read(routineProvider);

    image = workoutDraft!.image;
    titleController.text = workoutDraft!.workoutName;

    for (int i = 0; i < widget.workoutModel.exercises.length; i++) {
      final exerciseModel =
          WorkoutPostServices().mapExercise(widget.workoutModel.exercises[i]);
      workoutDraft!.fetchedExercises.add(exerciseModel);
    }
    loadingExercises = false;

    workoutDraft!.categories = widget.workoutModel.categories;
    workoutDraft!.workoutName = widget.workoutModel.workoutName;
    titleController.text = workoutDraft!.workoutName;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void delete(int index) {
      setState(() {
        widget.workoutModel.categories.removeAt(index);
      });
    }

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          // widget.workoutModel.workoutName = titleController.text;
          ref.invalidate(draftProvider);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              widget.workoutModel.uid == user!.uid
                  ? "Edit a Workout"
                  : "Create From Template",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            actions: [
              GestureDetector(
                onTap: () async {
                  String imageUrl = "";
                  if (image == null) {
                    imageUrl = widget.workoutModel.imageUrl;
                  }
                  if (titleController.text.isNotEmpty &&
                      // image != null &&
                      workoutDraft!.fetchedExercises.isNotEmpty) {
                    WorkoutModel workoutModel = WorkoutModel(
                        workoutName: titleController.text,
                        isTemplate: false,
                        categories: widget.workoutModel.categories,
                        exercises: List.empty(),
                        uid: user!.uid,
                        imageUrl: imageUrl,
                        postId: '',
                        templateId: widget.workoutModel.templateId,
                        createdAt: Timestamp.now(),
                        likeCount: 0,
                        likes: List.empty(),
                        privacy: 'public');

                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return const Center(child: CircularProgressIndicator());
                      },
                    );

                    try {
                      if (user!.uid == widget.workoutModel.uid) {
                        await WorkoutPostServices().editWorkout(
                            workoutModel,
                            workoutDraft!.fetchedExercises,
                            widget.workoutModel.postId,
                            widget.workoutModel.isTemplate);
                        if (image != null) {
                          await WorkoutPostServices()
                              .newImage(image!, widget.workoutModel.postId);
                        }
                      } else {
                        String futureString = await WorkoutPostServices()
                            .templateToWorkout(
                                workoutModel, workoutDraft!.fetchedExercises);
                        if (widget.day != 69) {
                          await RoutineServices().updateRoutine(
                              user!.uid,
                              widget.day,
                              futureString,
                              widget.workoutModel.postId);
                        }
                        if (image != null) {
                          await WorkoutPostServices()
                              .newImage(image!, futureString);
                        }
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          Commons().snackBarMessage(e.toString(), Colors.red));
                    }
                    // routine!.addToRoutine(widget.day, workoutModel);

                    if (context.mounted) {
                      context.pop();
                    }
                    Navigator.pop(context);
                    ref.invalidate(draftProvider);
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
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
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
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                            title: Text('Take A Picture')),
                                      ),
                                      Icon(Icons.camera_alt_outlined)
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(),
                              GestureDetector(
                                onTap: () => selectImage('Gallery'),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: ListTile(
                                              title:
                                                  Text('Choose From Gallery'))),
                                      Icon(Icons.image_outlined)
                                    ],
                                  ),
                                ),
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
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: ImageWidget(
                                    url: widget.workoutModel.imageUrl))
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
                            itemCount: widget.workoutModel.categories.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: PillWidget(
                                    editable: true,
                                    delete: () {
                                      delete(index);
                                    },
                                    name: widget.workoutModel.categories[index],
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
                          showModal(ModalEntry.aligned(context,
                              tag: 'containerModal',
                              barrierDismissible: true,
                              alignment: Alignment.center,
                              // removeOnPop: true,

                              child: Material(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      border: Border.all(
                                          width: 2,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                      borderRadius: BorderRadius.circular(10)),
                                  width: 300,
                                  height: 200,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CustomTextField(
                                          focusNode: focusNode,
                                          textController: categoryController,
                                          hintText: 'add a category'),
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              widget.workoutModel.categories
                                                  .add(categoryController.text);
                                              categoryController.text = '';
                                            });
                                            removeAllModals();
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child:
                                                CustomButton(buttonText: 'Add'),
                                          ))
                                    ],
                                  ),
                                ),
                              )));
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
                !loadingExercises
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: workoutDraft!.fetchedExercises.length,
                        itemBuilder: (context, index) {
                          return Builder(builder: (context) {
                            if (workoutDraft!
                                    .fetchedExercises[index].runtimeType ==
                                ExerciseModel) {
                              print(workoutDraft!.fetchedExercises[index]);
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    print(
                                        workoutDraft!.fetchedExercises[index]);
                                    context.pushNamed(
                                      RouteConstants.editExercise,
                                      extra: {
                                        "editingExercise": workoutDraft!
                                            .fetchedExercises[index],
                                        "index": index
                                      },
                                    );
                                  },
                                  child: Slidable(
                                    startActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            autoClose: true,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            flex: 1,
                                            onPressed: (context) {
                                              setState(() {
                                                workoutDraft!.fetchedExercises.add(
                                                    workoutDraft!
                                                        .fetchedExercises[index]);
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            flex: 1,
                                            onPressed: (context) {
                                              setState(() {
                                                workoutDraft!.fetchedExercises
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
                                    child: ExerciseWidget(
                                        exerciseModel: workoutDraft!
                                            .fetchedExercises[index]),
                                  ),
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    context.pushNamed(
                                        RouteConstants.localEditWorkout,
                                        extra: {
                                          "editingExercise": workoutDraft!
                                              .fetchedExercises[index],
                                          "index": index
                                        });
                                  },
                                  child: LocalExerciseWidget(
                                      exerciseModel: workoutDraft!
                                          .fetchedExercises[index]),
                                ),
                              );
                            }
                          });
                        },
                      )
                    : const Text('Loading')
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
                  context.pushNamed(
                    RouteConstants.createExercise,
                  );
                },
                child: const CustomButton(buttonText: 'Add Exercise')),
          ),
        ),
      ),
    );
  }
}
