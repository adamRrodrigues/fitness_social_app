import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/widgets/workout_widgets/workout_widget.dart';
import 'package:flutter/material.dart';

class FitnesstrackerPage extends StatefulWidget {
  const FitnesstrackerPage({Key? key}) : super(key: key);

  @override
  _FitnesstrackerPageState createState() => _FitnesstrackerPageState();
}

class _FitnesstrackerPageState extends State<FitnesstrackerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WorkoutWidget(
              workoutModel: WorkoutModel(
                  workoutName: 'test workout',
                  categories: ['test category'],
                  exercises: [],
                  uid: 'testUid',
                  postId: 'testPostID',
                  privacy: 'public')),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
            ),
          )
        ],
      ),
    );
  }
}
