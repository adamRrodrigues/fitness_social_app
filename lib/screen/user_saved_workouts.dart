import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_social_app/models/meal_model.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/services/feed_services.dart';
import 'package:fitness_social_app/services/meal_service.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/services/routine_services.dart';
import 'package:fitness_social_app/widgets/meal_widgets/meal_widget.dart';
import 'package:fitness_social_app/widgets/workout_widgets/workout_widget.dart';
import 'package:flutter/material.dart';

class UserSavedWorkouts extends StatelessWidget {
  const UserSavedWorkouts({Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            physics: const BouncingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                title: const Text("Saved"),
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              )
            ],
            body: Column(
              children: [
                TabBar(tabs: const [
                  Tab(
                    icon: Icon(Icons.fitness_center_rounded),
                  ),
                  Tab(
                    icon: Icon(Icons.food_bank),
                  ),
                ]),
                SizedBox(
                  height: 600,
                  child: TabBarView(
                      // physics: NeverScrollableScrollPhysics(),
                      children: [
                        workoutsSaved(),
                        mealsSaved(),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>> workoutsSaved() {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection("saved").doc(uid).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            List<dynamic> items = snapshot.data!.get('posts');
            if (items.isNotEmpty) {
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
                          snapshot.connectionState == ConnectionState.done) {
                        try {
                          Map<String, dynamic> thisWorkout =
                              snapshot.data!.data() as Map<String, dynamic>;

                          final WorkoutModel mappedWorkout =
                              WorkoutPostServices()
                                  .mapDocPostFuture(thisWorkout);

                          return WorkoutWidget(workoutModel: mappedWorkout);
                        } catch (e) {
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
              return Center(
                child: Text("No Workouts Saved"),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>> mealsSaved() {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection("saved").doc(uid).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            List<dynamic> items = snapshot.data!.get('meals');
            if (items.isNotEmpty) {
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('meals_demo')
                        .doc(items[index])
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        try {
                          Map<String, dynamic> thisMeal =
                              snapshot.data!.data() as Map<String, dynamic>;

                          final MealModel mappedMeal =
                              RoutineServices().mapSingleRoutineMeal(thisMeal);

                          return MealWidget(meal: mappedMeal);
                        } catch (e) {
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
              return Center(
                child: Text("No Meals Saved"),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
