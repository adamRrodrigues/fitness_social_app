import 'package:fitness_social_app/models/exercise_model.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/widgets/image_widget.dart';
import 'package:fitness_social_app/widgets/pill_widget.dart';
import 'package:fitness_social_app/widgets/workout_widgets/exercise_widget.dart';
import 'package:flutter/material.dart';

class ViewWorkout extends StatelessWidget {
  const ViewWorkout(
      {Key? key, required this.workoutModel, required this.postId})
      : super(key: key);
  final WorkoutModel workoutModel;
  final String postId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workoutModel.workoutName),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ImageWidget(url: workoutModel.imageUrl)),
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
                        itemCount: workoutModel.categories.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: PillWidget(
                                editable: false,
                                delete: () {},
                                name: workoutModel.categories[index],
                                active: false),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            workoutModel.exercises.isNotEmpty
                ? ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: workoutModel.exercises.length,
                    itemBuilder: (context, index) {
                      final exerciseModel = ExerciseModel(
                          name: workoutModel.exercises[index]['name'],
                          description: workoutModel.exercises[index]
                              ['description'],
                          weight: workoutModel.exercises[index]['weight'],
                          reps: workoutModel.exercises[index]['reps'],
                          sets: workoutModel.exercises[index]['sets']);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExerciseWidget(exerciseModel: exerciseModel),
                      );
                    },
                  )
                : Text('Any exercises you add will appear here')
          ],
        ),
      ),
    );
  }
}
