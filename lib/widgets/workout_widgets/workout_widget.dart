import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/widgets/pill_widget.dart';
import 'package:flutter/material.dart';

class WorkoutWidget extends StatelessWidget {
  const WorkoutWidget({Key? key, required this.workoutModel}) : super(key: key);
  final WorkoutModel workoutModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 4,
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('username'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(workoutModel.workoutName),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: workoutModel.categories.length,
                    itemBuilder: (context, index) {
                      return Expanded(
                        child: PillWidget(
                            name: workoutModel.categories[index], active: true),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
