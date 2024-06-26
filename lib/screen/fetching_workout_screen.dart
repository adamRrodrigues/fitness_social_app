import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/services/feed_services.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class FetchingWorkoutScreen extends StatefulWidget {
  const FetchingWorkoutScreen({Key? key, required this.workoutId})
      : super(key: key);
  final String workoutId;

  @override
  State<FetchingWorkoutScreen> createState() => _FetchingWorkoutScreenState();
}

class _FetchingWorkoutScreenState extends State<FetchingWorkoutScreen> {
  bool exists = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await FirebaseFirestore.instance
            .collection('workout_templates_demo')
            .doc(widget.workoutId)
            .get();
        exists = true;
      } catch (e) {
        exists = false;
      }
      setState(() {});
    });
  }

  Future getWorkout() async {
    if (exists == true) {
      FirebaseFirestore.instance
          .collection('workout_templates_demo')
          .doc(widget.workoutId)
          .get();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('id: ${widget.workoutId}');
    return Scaffold(
      body: Center(
        child: Builder(builder: (context) {
          if (!exists) {
            return (Center(
              child: Text(
                  "Sorry Looks Like This Template has Been Deleted By The User"),
            ));
          } else {
            return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('workout_templates_demo')
                    .doc(widget.workoutId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    final data = snapshot.data;
                    try {
                      final workout = FeedServices().mapSingleWorkout(data!);

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        //When finish, call actions inside
                        context.pushReplacementNamed(
                          RouteConstants.viewWorkoutScreen,
                          extra: workout,
                        );
                      });
                    } catch (e) {
                      return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('user_workouts_demo')
                            .doc(widget.workoutId)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            final newData = snapshot.data;
                            // print(widget.workoutId);
                            final workout =
                                FeedServices().mapSingleWorkout(newData!);

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              //When finish, call actions inside
                              context.pushReplacementNamed(
                                RouteConstants.viewWorkoutScreen,
                                extra: workout,
                              );
                            });
                            exists = false;
                          }
                          return Column(
                            children: [
                              LottieBuilder.network(
                                  "https://lottie.host/69d46a18-3885-495c-9076-fbc296a4c7a1/BlXniAaGlQ.json"),
                              const Text("Fetching Workout"),
                            ],
                          );
                        },
                      );
                    }

                    exists = true;
                  }
                  return const Text("Fetching Workout");
                });
            // return Container();
          }
        }),
      ),
    );
  }
}
