import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/feed/workout_feed.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/routine_model.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/services/feed_services.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    routine = ref.read(routineProvider);
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
          elevation: 0,
          title: Text(
            'Search Workout',
            style: Theme.of(context).textTheme.titleLarge,
          )),
      body: Column(
        children: [
          Expanded(
              child: WorkoutFeed(
            day: widget.index,
            uid: user!.uid,
            postQuery: FeedServices().fetchWorkouts(user.uid),
            profileView: false,
          ))
        ],
      ),
    );
  }
}
