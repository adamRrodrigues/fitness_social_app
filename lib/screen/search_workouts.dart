import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/feed/workout_feed.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/routine_model.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/screen/search_screens/workout_search.dart';
import 'package:fitness_social_app/services/feed_services.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/widgets/workout_widgets/workout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchWorkouts extends ConsumerStatefulWidget {
  const SearchWorkouts(this.index, {Key? key}) : super(key: key);
  final int index;
  @override
  _SearchWorkoutsState createState() => _SearchWorkoutsState();
}

class _SearchWorkoutsState extends ConsumerState<SearchWorkouts> {
  Routine routine = Routine();
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
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Search Workout',
            style: Theme.of(context).textTheme.titleLarge,
          )),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: [
                Tab(
                    icon: Icon(
                  Icons.person_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                )),
                Tab(
                    icon: Icon(
                  Icons.bookmark_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                )),
                Tab(
                    icon: Icon(
                  Icons.search_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                )),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  WorkoutFeed(
                    profileView: true,
                    selection: true,
                    day: widget.index,
                    uid: user!.uid,
                    postQuery: FeedServices().fetchUserWorkouts(user.uid),
                  ),
                  workoutsSaved(),
                  WorkoutSearch(
                    selection: true,
                    day: widget.index,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>> workoutsSaved() {
    return FutureBuilder(
        future:
            FirebaseFirestore.instance.collection("saved").doc(user!.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            List<dynamic> items = snapshot.data!.get('posts');
            if (items.isNotEmpty) {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
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
                              .removeFromSavedWorkouts(items[index], user!.uid);
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
}
