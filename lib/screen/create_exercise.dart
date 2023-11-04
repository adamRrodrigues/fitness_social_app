import 'package:fitness_social_app/commons/commons.dart';
import 'package:fitness_social_app/models/exercise_model.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:fitness_social_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:numberpicker/numberpicker.dart';

class CreateExercise extends StatefulWidget {
  const CreateExercise({Key? key, required this.exercises}) : super(key: key);
  final List<ExerciseModel> exercises;

  @override
  _CreateExerciseState createState() => _CreateExerciseState();
}

class _CreateExerciseState extends State<CreateExercise> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  double weightValue = 0;
  int repValue = 0;
  int setValue = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('create an exercise'),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomTextField(
              textController: nameController, hintText: 'exercise name'),
          SizedBox(
            height: 10,
          ),
          CustomTextField(
              textController: descriptionController, hintText: 'description'),
          SizedBox(
            height: 10,
          ),
          NumberPicker(
            itemHeight: 35,
            itemWidth: 40,
            minValue: 0,
            maxValue: 100,
            value: weightValue.toInt(),
            onChanged: (value) {
              setState(() {
                weightValue = value.toDouble();
              });
            },
          ),
          Text('Weight: $weightValue' 'kgs'),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    NumberPicker(
                      itemHeight: 35,
                      itemWidth: 40,
                      minValue: 0,
                      maxValue: 100,
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
                      itemHeight: 35,
                      itemWidth: 40,
                      minValue: 0,
                      maxValue: 100,
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
          SizedBox(
            height: 20,
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        padding: EdgeInsets.all(8),
        color: Colors.transparent,
        elevation: 0,
        child: GestureDetector(
            onTap: () {
              if (nameController.text.isNotEmpty) {
                ExerciseModel exerciseModel = ExerciseModel(
                    name: nameController.text,
                    description: descriptionController.text,
                    weight: weightValue,
                    reps: repValue,
                    sets: setValue);
                widget.exercises.add(exerciseModel);
                context.pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(Commons()
                    .snackBarMessage('Exercise must have a name', Colors.red));
              }
            },
            child: CustomButton(buttonText: 'Done')),
      ),
    );
  }
}
