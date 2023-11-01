import 'dart:typed_data';

import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/exercise_model.dart';
import 'package:fitness_social_app/utlis/utils.dart';
import 'package:fitness_social_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CreateWorkoutPost extends ConsumerStatefulWidget {
  const CreateWorkoutPost({Key? key}) : super(key: key);

  @override
  _CreateWorkoutPostState createState() => _CreateWorkoutPostState();
}

class _CreateWorkoutPostState extends ConsumerState<CreateWorkoutPost> {
  TextEditingController titleController = TextEditingController();

  Uint8List? image;

  Utils? imagePicker;

  List<ExerciseModel> exercises = [];

  void selectImage() async {
    try {
      Uint8List file = await imagePicker!.pickImage(ImageSource.gallery);

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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Create a Workout"),
        ),
        body: Stack(
          children: [
            Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      selectImage();
                    },
                    child: Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary)),
                      child: image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image(
                                image: MemoryImage(image!),
                                fit: BoxFit.cover,
                              ))
                          : Center(
                              child: Icon(Icons.add_a_photo),
                            ),
                    ),
                  ),
                ),
                CustomTextField(
                    textController: titleController,
                    hintText: 'Give Your Workout a Name'),
                Expanded(
                  // height: 200,
                  child: ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      return Text(exercises[index].name);
                    },
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      exercises.add(ExerciseModel(
                          name: 'name',
                          description: 'description',
                          weight: 20,
                          sets: 3));
                    });
                  },
                  child: Icon(Icons.add),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
