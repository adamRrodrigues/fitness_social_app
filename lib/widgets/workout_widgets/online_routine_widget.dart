import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/routine_model.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/services/routine_services.dart';
import 'package:fitness_social_app/widgets/workout_widgets/workout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OnlineRoutineWidget extends ConsumerStatefulWidget {
  const OnlineRoutineWidget({
    super.key,
    required this.uid,
    required this.currentDay,
  });

  final String? uid;
  final int currentDay;

  @override
  _OnlineRoutineWidgetState createState() => _OnlineRoutineWidgetState();
}

class _OnlineRoutineWidgetState extends ConsumerState<OnlineRoutineWidget> {
  Routine? routine;
  User? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    routine = ref.read(routineProvider);
    user = ref.read(userProvider);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('routines')
          .doc(widget.uid)
          .collection('day ${widget.currentDay}')
          .doc('workouts')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.active) {
          List<dynamic> workouts = [];
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          if (data['workouts'].isNotEmpty) {
            for (int i = 0; i < data['workouts'].length; i++) {
              workouts.add(data['workouts'][i]);
            }
          }
          return data['workouts'].isNotEmpty
              ? ListView.builder(
                  addAutomaticKeepAlives: true,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: data['workouts'].length,
                  itemBuilder: (context, index) {
                    return Slidable(
                      endActionPane: ActionPane(
                          extentRatio: 0.3,
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              // An action can be bigger than the others.
                              borderRadius: BorderRadius.circular(10),
                              autoClose: true,
                              flex: 1,
                              onPressed: (context) {
                                // setState(() {

                                // });
                                RoutineServices().removeFromWorkoutRoutine(
                                    data['workouts'][index]['templateId'],
                                    data['workouts'][index]['userWorkoutId'],
                                    widget.currentDay);
                                routine!.clearRoutine(widget.currentDay);
                              },
                              backgroundColor: Colors.redAccent,
                              foregroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              icon: Icons.delete,
                              label: 'Remove',
                            ),
                          ]),
                      child: FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('user_workouts_demo')
                              .doc(workouts[index]['userWorkoutId'])
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.connectionState ==
                                    ConnectionState.done) {
                              try {
                                Map<String, dynamic> thisWorkout =
                                    snapshot.data!.data()
                                        as Map<String, dynamic>;

                                final WorkoutModel mappedWorkout =
                                    WorkoutPostServices()
                                        .mapDocPostFuture(thisWorkout);

                                if (routine!.routines[widget.currentDay]
                                        .workouts.length !=
                                    data['workouts'].length) {
                                  routine!.addToRoutine(
                                      widget.currentDay, mappedWorkout);
                                }
                                return WorkoutWidget(
                                  workoutModel: mappedWorkout,
                                );
                              } catch (e) {
                                RoutineServices().removeFromWorkoutRoutine(
                                    data['workouts'][index]['templateId'],
                                    data['workouts'][index]['userWorkoutId'],
                                    widget.currentDay);
                                return Container();
                              }
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          }),
                    );
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
