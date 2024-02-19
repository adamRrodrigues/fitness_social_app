import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/services/routine_services.dart';
import 'package:fitness_social_app/widgets/workout_widgets/workout_widget.dart';
import 'package:flutter/material.dart';

class OnlineRoutineWidget extends StatelessWidget {
  const OnlineRoutineWidget({
    super.key,
    required this.uid,
    required this.currentDay,
  });

  final String? uid;
  final int currentDay;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('routines')
          .doc(uid)
          .collection('day $currentDay')
          .doc('workouts')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.active) {
              print(currentDay);
          List<String> workouts = [];
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          if (data['workouts'].isNotEmpty) {
            for (int i = 0; i <= data['workouts'].length; i++) {
              workouts.add(['workouts'][0]);
              // print(workouts);
            }
          }
          return data['workouts'].isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: data['workouts'].length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('user_workouts_demo')
                            .doc(data['workouts'][index]['userWorkoutId'])
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            Map<String, dynamic> thisWorkout =
                                snapshot.data!.data() as Map<String, dynamic>;

                            final WorkoutModel mappedWorkout = RoutineServices()
                                .mapSingleRoutineWorkout(thisWorkout);
                            return WorkoutWidget(workoutModel: mappedWorkout);
                          } else {
                            return Text('loading');
                          }
                        });
                  },
                )
              : const Text('empty');
        } else {
          return const Text('Error');
        }
      },
    );
  }
}
