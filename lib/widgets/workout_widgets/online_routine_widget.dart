import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/routine_model.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/services/routine_services.dart';
import 'package:fitness_social_app/widgets/workout_widgets/workout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnlineRoutineWidget extends ConsumerWidget {
  const OnlineRoutineWidget({
    super.key,
    required this.uid,
    required this.currentDay,
  });

  final String? uid;
  final int currentDay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Routine routinesStored = ref.read(routineProvider);
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
              print(workouts);
            }
          }
          return data['workouts'].isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                            try {
                              Map<String, dynamic> thisWorkout =
                                  snapshot.data!.data() as Map<String, dynamic>;

                              final WorkoutModel mappedWorkout =
                                  WorkoutPostServices()
                                      .mapDocPostFuture(thisWorkout);
                              print(mappedWorkout);

                              if (routinesStored
                                      .routines[currentDay].workouts.length !=
                                  data['workouts'].length) {
                                routinesStored.addToRoutine(
                                    currentDay, mappedWorkout);
                              }
                              return WorkoutWidget(workoutModel: mappedWorkout);
                            } catch (e) {
                              RoutineServices().removeFromWorkoutRoutine(
                                  data['workouts'][index]['templateId'],
                                  data['workouts'][index]['userWorkoutId'],
                                  currentDay);
                              return Container();
                            }
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        });
                  },
                )
              : const Center(child: Text('No Wokouts for this day'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
