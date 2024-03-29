import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/feed/workout_feed.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/routine_model.dart';
import 'package:fitness_social_app/screen/search_screens/workout_search.dart';
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
        length: 2,
        child: Column(
          children: [
            TabBar(
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: [
                Tab(
                    icon: Icon(
                  Icons.fitness_center_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                )),
                Tab(
                    icon: Icon(
                  Icons.bookmark_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                )),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  WorkoutSearch(
                    selection: true,
                    day: widget.index,
                  ),
                  WorkoutFeed(
                    profileView: true,
                    selection: true,
                    day: widget.index,
                    uid: user!.uid,
                    postQuery: FeedServices().fetchUserWorkouts(user.uid),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
