import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/widgets/workout_widgets/workout_widget.dart';
import 'package:flutter/material.dart';

class UserSavedWorkouts extends StatelessWidget {
  const UserSavedWorkouts({Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) =>
              [const SliverAppBar(title: Text("Saved Workouts"))],
          body: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("saved")
                  .doc(uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  List<dynamic> items = snapshot.data!.get('posts');
                  print(items);
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('workout_templates_demo')
                            .doc(items[index])
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

                              return WorkoutWidget(workoutModel: mappedWorkout);
                            } catch (e) {
                              print(items[index]);
                              WorkoutPostServices()
                                  .removeFromSavedWorkouts(items[index], uid);
                              return Container();
                            }
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
}
